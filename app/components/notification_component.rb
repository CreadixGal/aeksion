# frozen_string_literal: true

class NotificationComponent < ViewComponent::Base
  attr_reader :type, :data, :border_color

  def initialize(type:, data:)
    super
    @type = type
    @data = prepare_data(data)
    @border_color = color
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

  def color
    case @type
    when 'success'
      'border-b-green-400'
    when 'error'
      'border-b-red-500'
    when 'alert'
      'border-b-orange-500'
    when 'info'
      'border-b-indigo-400'
    else
      'border-b-blue-400'
    end
  end
end
