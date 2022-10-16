# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MenuItemComponent, type: :component do
  let(:test_url) { 'http://test.com' }

  let(:full_params) do
    {
      icon: 'truck.svg',
      icon_style: 'w-12 h-12',
      link_style: 'text-gray-600 hover:text-gray-900'
    }
  end

  it 'renders default menu item' do
    render_inline(described_class.new(item: 'box', path: test_url))

    expect(page).to have_link href: test_url
    expect(page).to have_css 'a#box', class: 'menu-item-component'
  end

  it 'renders full menu item' do
    render_inline(described_class.new(item: 'box', path: test_url, options: full_params))

    expect(page).to have_link href: test_url
    expect(page).to have_css 'a#box', class: 'text-gray-600 hover:text-gray-900'
    expect(page).not_to have_css 'a#box', class: 'menu-item-component'
  end
end
