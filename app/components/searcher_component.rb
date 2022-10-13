# frozen_string_literal: true

class SearcherComponent < ViewComponent::Base
  attr_reader :path, :placeholder, :form_style, :input_style

  def initialize(path:, options: {})
    super
    @path         = path
    @placeholder  = options[:placeholder] || 'Search...'
    @form_style   = options[:form_style]  || 'search-form-component focus:outline-none focus:shadow-outline'
    @input_style  = options[:input_style] || 'w-full'
  end
end
