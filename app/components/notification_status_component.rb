# frozen_string_literal: true

class NotificationStatusComponent < ViewComponent::Base
  attr_reader :status, :count, :color

  def initialize(status:, count: 0)
    super
    @status = status
    @count = count
    @color = status_color[status]
  end

  def status_color
    {
      'pending' => 'bg-red-500',
      'viewed' => 'bg-indigo-500',
      'in_progress' => 'bg-amber-500',
      'completed' => 'bg-green-500'
    }
  end

  def span_badge
    return '' if count.zero?

    content_tag :span, class: 'absolute w-6 h-6 top-2 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/2 -translate-y-1/2 bg-red-500 rounded-full' do
      count.to_s
    end
  end
end
