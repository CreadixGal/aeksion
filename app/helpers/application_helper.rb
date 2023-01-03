module ApplicationHelper
  include Pagy::Frontend

  def circle_percentage(count_type, total)
    ((count_type * 100) / total)
  rescue ZeroDivisionError
    0
  end
end
