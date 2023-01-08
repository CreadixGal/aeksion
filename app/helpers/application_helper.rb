module ApplicationHelper
  include Pagy::Frontend

  def circle_percentage(count_type, total)
    result = count_type.to_f * 100
    result /= total.to_f
    result
  rescue ZeroDivisionError
    0
  end
end
