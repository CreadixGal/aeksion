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

  # helper for list_component
  def object_to_li(record, attrs)
    attrs.map do |attr|
      if block_given? && yield(record, attr)
        yield(record, attr)
      else
        record.send(attr)
      end
    end
  end
  
  # helper for list_component
  def linked_cell_content(record, attr, options)
    option = options.find { |o| o[:attr] == attr }
    if option
      link_to record.send(attr), option[:path], class: option[:style].presence || ""
    else
      record.send(attr)
    end
  end
end
