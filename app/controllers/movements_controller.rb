class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show]

  def index
    @movements = Movement.all.order(created_at: :desc)
    @pagy, @movements = pagy(@movements, items: 10)
  end

  def show; end

  def new
    @movement = Movement.new
  end

  private

  def set_movement
    @movement = Movement.find(params[:id])
  end
end