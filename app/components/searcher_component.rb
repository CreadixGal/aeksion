# frozen_string_literal: true

class SearcherComponent < ViewComponent::Base
  attr_reader :path, :placeholder, :form_style, :input_style

  def initialize(path:, options: {})
    @path         = path
    @placeholder  = options[:placeholder] || 'Search...'
    @form_style   = options[:form_style]  || 'w-2/5 mx-2 text-gray-700 leading-tight focus:outline-none focus:shadow-outline'
    @input_style  = options[:input_style] || 'w-full'
  end
end
