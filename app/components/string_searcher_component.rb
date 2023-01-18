# frozen_string_literal: true

class StringSearcherComponent < ViewComponent::Base
  attr_reader :path, :placeholder, :kind, :regex, :attribute

  def initialize(path:, attribute:, options: {})
    super
    @path         = path
    @attribute    = attribute
    @placeholder  = options[:placeholder] || 'Search...'
    @kind         = options[:kind]        || nil
    @regex        = options[:regex]       || ''
  end
end
