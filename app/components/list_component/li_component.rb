# frozen_string_literal: true

class ListComponent::LiComponent < ViewComponent::Base
  renders_one :actions, 'LiActionComponent'

  attr_reader :cells, :resource, :delete_info

  def initialize(resource:, cells:, delete_info: 'name')
    super
    @cells = cells
    @resource = resource
    @delete_info = delete_info
  end

  def html_id
    "#{resource.model_name.param_key}_#{resource.id}"
  end

  def html_new
    "new_#{resource.model_name.param_key}"
  end

  def resource_value
    @resource.public_send(@delete_info)
  end

  class LiActionComponent < ViewComponent::Base
    def call
      tag.div content,
              class: 'flex justify-content items-center gap-4 text-sm text-gray-900 font-light whitespace-nowrap'
    end

    def render?
      content.present?
    end
  end
end
