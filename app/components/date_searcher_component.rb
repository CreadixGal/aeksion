# frozen_string_literal: true

class DateSearcherComponent < ViewComponent::Base
  attr_reader :path, :placeholder, :kind, :regex, :zero, :name, :range, :product_kind

  def initialize(path:, options: {})
    super
    @path         = path
    @placeholder  = options[:placeholder]  || 'Search...'
    @kind         = options[:kind]         || nil
    @zero         = options[:zero]         || nil
    @name         = options[:name]         || nil
    @range        = options[:range]        || nil
    @product_kind = options[:product_kind] || nil
  end
end
