# frozen_string_literal: true

class StringSearcherComponent < ViewComponent::Base
  attr_reader :path, :placeholder, :kind, :range, :regex, :attribute, :zero

  def initialize(path:, attribute:, options: {})
    super
    @path         = path
    @attribute    = attribute
    @placeholder  = options[:placeholder] || 'Search...'
    @kind         = options[:kind]        || nil
    @range        = options[:range]       || nil
    @zero         = options[:zero]        || nil
    @regex        = options[:regex]       || ''
  end
end
