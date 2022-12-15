# frozen_string_literal: true

class NotificationComponent < ViewComponent::Base
  attr_reader :type, :data, :border_color, :stroke_color

  def initialize(type:, data:)
    super
    @type = type
    @data = prepare_data(data)
    @border_color = border_color
    @stroke_color = stroke_color
    @data[:timeout] ||= 10
  end

  private

  def prepare_data(data)
    case data
    when Hash
      data
    else
      { title: data }
    end
  end

  def border_color
    case @type
    when 'success'
      'border-t-green-400'
    when 'error'
      'border-t-red-500'
    when 'alert'
      'border-t-orange-500'
    when 'info'
      'border-t-indigo-400'
    else
      'border-t-blue-400'
    end
  end

  def stroke_color
    case @type
    when 'success'
      'stroke-green-400'
    when 'error'
      'stroke-red-500'
    when 'alert'
      'stroke-orange-500'
    when 'info'
      'stroke-indigo-400'
    else
      'border-t-blue-400'
    end
  end

  def icon
    case @type
    when 'success'
      'check-circle'
    when 'error'
      'exclamation-circle'
    when 'alert'
      'exclamation-triangle'
    when 'info'
      'info-circle'
    else
      'info-circle'
    end
  end
end
