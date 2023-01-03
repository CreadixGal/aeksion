class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index; end

  def dashboard
    @customers              = Customer.all
    @total_movements        = Movement.all
    @total_deliveries       = Movement.delivery
    @total_pickups          = Movement.pickup
    @last_month_movements   = Movement.where(date: 1.month.ago.all_month)
    @last_month_deliveries  = Movement.delivery.where(date: 1.month.ago.all_month)
    @last_month_pickups     = Movement.pickup.where(date: 1.month.ago.all_month)
    @this_year_movements    = Movement.where(date: Time.zone.now.all_year)
    @this_year_deliveries   = Movement.delivery.where(date: Time.zone.now.all_year)
    @this_year_pickups      = Movement.pickup.where(date: Time.zone.now.all_year)
    @this_week_movements    = Movement.where(date: Time.zone.now.all_week)
    @this_week_deliveries   = Movement.delivery.where(date: Time.zone.now.all_week)
    @this_week_pickup       = Movement.pickup.where(date: Time.zone.now.all_week)
  end
end
