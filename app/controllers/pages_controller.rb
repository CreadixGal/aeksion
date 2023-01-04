class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index; end

  def dashboard
    @comparision_delivery   = comparison_amount(Movement.delivery)
    @comparision_pickup     = comparison_amount(Movement.pickup)
    @customers              = Customer.all
    @total_movements        = Movement.all
    @total_deliveries       = Movement.delivery
    @total_pickups          = Movement.pickup
    @last_month_deliveries  = Movement.delivery.where(date: 1.month.ago.all_month)
    @last_month_movements   = Movement.where(date: 1.month.ago.all_month)
    @last_month_pickups     = Movement.pickup.where(date: 1.month.ago.all_month)
    @this_year_movements    = Movement.where(date: Time.zone.now.all_year)
    @this_year_deliveries   = Movement.delivery.where(date: Time.zone.now.all_year)
    @this_year_pickups      = Movement.pickup.where(date: Time.zone.now.all_year)
    @this_week_movements    = Movement.where(date: Time.zone.now.all_week)
    @this_week_deliveries   = Movement.delivery.where(date: Time.zone.now.all_week)
    @this_week_pickup       = Movement.pickup.where(date: Time.zone.now.all_week)
  end

  def print_circle(kind, range: nil)
    time = 'Time.zone.now'.concat range unless range.nil?
    # rubocop:disable Security/Eval
    kinds = range.nil? ? Movement.send(kind) : Movement.send(type).where(date: eval(time))
    # rubocop:enable Security/Eval
    movements = Movement.all
    circle_percentage(kinds, movements)
  end

  def comparison_amount(movements)
    now  = movements.where(date: Time.zone.now.all_month).includes(:product_movements)
    last = movements.where(date: 1.month.ago.all_month).includes(:product_movements)

    last_amount = last.sum(:amount)
    amount = now.sum(:amount)
    amount > last_amount
  end
end
