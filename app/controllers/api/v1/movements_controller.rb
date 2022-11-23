class Api::V1::MovementsController < Api::V1::BaseController
    def index
        movements = Movement.all
        json_render(movements)
    end
  
    def show
        movement = Movement.find(params[:id])
        json_render(movement)
    end
  
    def create
        movements = params[:movements].map do |movement|            
            {        
                rate_id: movement[:rate_id],
                date: movement[:date]
            }
        end
        
        Movement.upsert_all(movements)
    
        json_render(movements)
    end
  
    def bulk_update
        movements = params[:movements].map do |movement|
            {        
                id: movement[:id],
                rate_id: movement[:rate_id],
                date: movement[:date]
            }
        end
        
        Movement.upsert_all(movements, unique_by: :id)

        json_render(movements)
    end
  
    def destroy
        movement = Movement.find(params[:movements][0][:id])
        movement.product_movements.destroy if movement.product_movements.present?
        movement.destroy
    end
  end
  