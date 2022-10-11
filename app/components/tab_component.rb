# frozen_string_literal: true

class TabComponent < ViewComponent::Base
  attr_reader :item, :text, :path, :icon, :icon_style, :link_style, :turbo, :notification
  
  def initialize(item:, path:, options: {})
    @item           = item
    @path           = path
    @text           = options[:text] 
    @icon           = options[:icon]
    @notification   = options[:notification]
    @icon_style     = options[:icon_style].presence  || 'w-8 h-8'
    @link_style     = options[:link_style].presence  || 'w-full flex items-center justify-center py-5 hover:bg-gray-900 hover:text-gray-300'
  end

  def render? 
    item.present? && path.present?
  end
end
