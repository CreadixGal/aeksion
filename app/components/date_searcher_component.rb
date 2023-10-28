# frozen_string_literal: true

class DateSearcherComponent < ViewComponent::Base
  attr_reader :path, :placeholder, :kind, :regex, :attribute, :zero, :name

  def initialize(path:, attribute:, options: {})
    super
    @path         = path
    @attribute    = attribute
    @placeholder  = options[:placeholder] || 'Search...'
    @kind         = options[:kind]        || nil
    @zero         = options[:zero]        || nil
    @name         = options[:name]        || nil
  end
end
