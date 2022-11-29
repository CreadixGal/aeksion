class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show edit]

  def index
    @movements = Movement.includes([:rate]).all.order(created_at: :desc)
    @pagy, @movements = pagy(@movements, items: 10)
  end

  def show; end

  def new
    @movement = Movement.new
  end
  
  def create
    @movement = Movement.new(movement_params)

    respond_to do |format|
      if @movement.save
        format.html { redirect_to movements_path, success: 'Movement was successfully created.' }
        format.turbo_stream { flash.now[:success] = 'Movement was successfully created.' }
      else
        format.html { render :new, error: 'Movement was not created.' }
        format.turbo_stream { flash.now[:error] = 'Movement was not created.' }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  private
  def movement_params
    params.require(:movement).permit(:rate_id, :date)
  end
  def set_movement
    @movement = Movement.find(params[:id])
  end
end