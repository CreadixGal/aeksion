class PagesController < ApplicationController
  include ApplicationHelper
  skip_before_action :authenticate_user!, only: :index
  def index; end

  def dashboard
    @customers                  = Customer.all
    @total_movements            = Movement.all
    @last_month_deliveries      = print_circle('delivery',  range: '.prev_month.all_month')
    @this_month_deliveries      = print_circle('delivery',  range: '.all_month')
    @this_week_deliveries       = print_circle('delivery',  range: '.all_week')
    @this_year_deliveries       = print_circle('delivery',  range: '.all_year')
    @total_deliveries           = print_circle('delivery')
    @last_month_pickups         = print_circle('pickup',    range: '.prev_month.all_month')
    @this_month_pickups         = print_circle('pickup',    range: '.all_month')
    @this_year_pickups          = print_circle('pickup',    range: '.all_year')
    @this_week_pickups          = print_circle('pickup',    range: '.all_week')
    @total_pickups              = print_circle('pickup')
    @comparision_month_delivery = comparison_amount(Movement.delivery,  'month')
    @comparision_year_delivery  = comparison_amount(Movement.delivery,  'year')
    @comparision_month_pickup   = comparison_amount(Movement.pickup,    'month')
    @comparision_year_pickup    = comparison_amount(Movement.pickup,    'year')
  end

  private

  def print_circle(kind, range: nil)
    time = 'Time.now'.concat range unless range.nil?
    # rubocop:disable Security/Eval
    movements = range.nil? ? Movement.all          : Movement.where(date: eval(time))
    kinds     = range.nil? ? Movement.send(kind)   : Movement.send(kind).where(date: eval(time))
    # rubocop:enable Security/Eval
    circle_percentage(kinds.size, movements.size)
  end

  def comparison_amount(movements, range)
    prev = Time.zone.now.prev_year.all_year    if range.eql? 'year'
    now  = Time.zone.now.all_year              if range.eql? 'year'
    prev = Time.zone.now.prev_month.all_month  if range.eql? 'month'
    now  = Time.zone.now.all_month             if range.eql? 'month'

    actual  = movements.where(date: now).includes(:product_movements)
    last    = movements.where(date: prev).includes(:product_movements)

    last_amount = last.sum(:amount)
    amount      = actual.sum(:amount)
    amount > last_amount
  end
end
