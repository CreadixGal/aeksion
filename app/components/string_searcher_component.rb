# frozen_string_literal: true

class StringSearcherComponent < ViewComponent::Base
  attr_reader :path, :placeholder, :kind, :range, :regex, :attribute, :zero, :product_kind

  def initialize(path:, attribute:, options: {})
    super
    @path         = path
    @attribute    = attribute
    @placeholder  = options[:placeholder]  || 'Search...'
    @kind         = options[:kind]         || nil
    @range        = options[:range]        || nil
    @zero         = options[:zero]         || nil
    @regex        = options[:regex]        || ''
    @product_kind = options[:product_kind] || nil
  end
end
