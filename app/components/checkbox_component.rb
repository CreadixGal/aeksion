# frozen_string_literal: true

class CheckboxComponent < ViewComponent::Base
  attr_reader :id, :name, :options, :value, :action, :target, :kind

  def initialize(id:, name:, options: {})
    super
    @id     = id
    @name   = name
    @options = options
    @kind   = options[:kind].presence               || nil
    @value  = options[:value].presence              || nil
    @action = options[:action].presence             || 'checkParent'
    @target = options[:target].presence             || 'child'
  end

  def label
    @target == 'child' ? id.tr('-', ' ').titleize : 'Seleccionar todos'
  end

  def label_style
    options[:label_style].presence || 'checkbox-label'
  end

  def wrap_style
    options[:wrap_style].presence || 'checkbox-wrap'
  end

  def input_style
    options[:input_style].presence || 'checkbox-input'
  end

  def show
    options[:display_label].presence || false
  end

  def render?
    id.present?
  end
end
