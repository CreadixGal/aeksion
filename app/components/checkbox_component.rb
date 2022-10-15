# frozen_string_literal: true

class CheckboxComponent < ViewComponent::Base
  attr_reader :id, :value, :action, :target, :style, :show

  def initialize(id:, options: {})
    super
    @id     = id
    @value  = options[:value].presence          || nil
    @action = options[:action].presence         || 'checkParent'
    @target = options[:target].presence         || 'child'
    @style  = options[:style].presence          || 'checkbox-default'
    @show   = options[:display_label].presence  || false
  end

  def label
    @target == 'child' ? id.tr('-', ' ').titleize : 'Seleccionar todos'
  end

  def render?
    id.present?
  end
end
