# frozen_string_literal: true

class ConfigurationCardComponent < ViewComponent::Base
  attr_reader :icon, :title, :description, :link1, :link2, :href1, :href2

  def initialize(title:, description: nil, options: {})
    super
    @title        = title.capitalize
    @description  = description.presence || "Consultar, editar y eliminar #{title.downcase}"
    @icon         = options[:icon].presence || 'info-circle.svg'
    @link1       = options[:link1].presence || 'Consultar'
    @link2       = options[:link2].presence || 'Añadir'
    @href1       = options[:href1]
    @href2       = options[:href2]
  end

  def render?
    title.present?
  end
end
