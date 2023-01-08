# frozen_string_literal: true

class CheckboxComponent < ViewComponent::Base
  attr_reader :id, :name, :value, :action, :target, :style, :show, :kind

  def initialize(id:, name:, options: {})
    super
    @id     = id
    @name   = name
    @value  = options[:value].presence          || nil
    @action = options[:action].presence         || 'checkParent'
    @target = options[:target].presence         || 'child'
    @style  = options[:style].presence          || 'checkbox-default'
    @show   = options[:display_label].presence  || false
    @kind   = options[:kind].presence           || nil
  end

  def label
    @target == 'child' ? id.tr('-', ' ').titleize : 'Seleccionar todos'
  end

  def render?
    id.present?
  end
end
