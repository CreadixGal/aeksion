class PagesController < ApplicationController
  include ApplicationHelper
  skip_before_action :authenticate_user!, only: :index
  def index; end

  def dashboard
    @comparision_delivery   = comparison_amount(Movement.delivery)
    @comparision_pickup     = comparison_amount(Movement.pickup)
    @customers              = Customer.all
    @total_movements        = Movement.all
    @this_month_deliveries  = print_circle('delivery',  range: '.all_month')
    @this_week_deliveries   = print_circle('delivery',  range: '.all_week')
    @this_year_deliveries   = print_circle('delivery',  range: '.all_year')
    @total_deliveries       = print_circle('delivery')
    @this_month_pickups     = print_circle('pickup',    range: '.all_month')
    @this_year_pickups      = print_circle('pickup',    range: '.all_year')
    @this_week_pickups      = print_circle('pickup',    range: '.all_week')
    @total_pickups          = print_circle('pickup')
  end

  private

  def print_circle(kind, range: nil)
    time = 'Time.zone.now'.concat range unless range.nil?
    # rubocop:disable Security/Eval
    movements = range.nil? ? Movement.all          : Movement.where(date: eval(time))
    kinds     = range.nil? ? Movement.send(kind)   : Movement.send(kind).where(date: eval(time))
    # rubocop:enable Security/Eval
    circle_percentage(kinds.size, movements.size)
  end

  def comparison_amount(movements)
    now  = movements.where(date: Time.zone.now.all_month).includes(:product_movements)
    last = movements.where(date: 1.month.ago.all_month).includes(:product_movements)

    last_amount = last.sum(:amount)
    amount = now.sum(:amount)
    amount > last_amount
  end
end
