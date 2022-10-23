# frozen_string_literal: true

class ConfigurationCardComponent < ViewComponent::Base
  attr_reader :icon, :title, :description, :link_1, :link_2, :href_1, :href_2

  def initialize(title:, description:, options: {})
    super
    @title        = title
    @description  = description
    @icon         = options[:icon].presence   || 'info-circle.svg'
    @link_1       = options[:link_1].presence || 'Consultar'
    @link_2       = options[:link_2]
    @href_1       = options[:href_1]
    @href_2       = options[:href_2]
  end
  
  def render?
    title.present?
  end
end
