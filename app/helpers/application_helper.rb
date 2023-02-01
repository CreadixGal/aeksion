module ApplicationHelper
  include Pagy::Frontend

  def circle_percentage(count_type, total)
    return 0 if total.zero?

    result = count_type.to_f * 100
    result /= total.to_f
    result
  end

  def proccess_movement(movement)
    if movement.progress?
      'Iniciado'
    elsif movement.finished?
      'Finalizado'
    end
  end
end
