# frozen_string_literal: true

class MenuItemComponent < ViewComponent::Base
  attr_reader :item, :path, :icon, :icon_style, :link_style
  
  def initialize(item:, path:, options: {})
    @item       = item
    @path       = path
    @icon       = options[:icon].presence        || 'x-circle.svg'
    @icon_style = options[:icon_style].presence  || 'w-8 h-8'
    @link_style = options[:link_style].presence  || 'w-full flex items-center justify-center py-5 hover:bg-gray-700 hover:text-gray-300'
  end

  def render? 
    item.present? && path.present?
  end
end
