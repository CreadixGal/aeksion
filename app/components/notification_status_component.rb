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

    content_tag :span,
                class: 'notification-status-info' do
      count.to_s
    end
  end
end
