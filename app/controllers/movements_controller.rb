class MovementsController < ApplicationController
  def index
    @movements = Movement.all.order(created_at: :desc)
    @pagy, @movements = pagy(@movements, items: 10)
  end
end