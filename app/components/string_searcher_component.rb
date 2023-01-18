# frozen_string_literal: true

class StringSearcherComponent < ViewComponent::Base
  attr_reader :path, :placeholder, :form_style, :input_style, :kind, :regex, :attribute

  def initialize(path:, attribute:, options: {})
    super
    @path         = path
    @attribute    = attribute
    @placeholder  = options[:placeholder] || 'Search...'
    @form_style   = options[:form_style]  || 'search-form-component focus:outline-none focus:shadow-outline'
    @input_style  = options[:input_style] || 'w-full'
    @kind         = options[:kind]        || nil
    @regex        = options[:regex]       || ''
  end
end
