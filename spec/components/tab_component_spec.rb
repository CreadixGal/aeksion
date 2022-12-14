# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TabComponent, type: :component do
  context 'renders tab item' do
    let(:test_url) { 'http://test.com' }

    let(:full_params) do
      {
        icon: 'truck.svg',
        notification: '5',
        link_style: 'tab-component'
      }
    end

    it 'with default paramaeters' do
      render_inline(described_class.new(item: 'one', path: test_url))

      expect(page).to have_link href: test_url
      expect(page).to have_css 'a#one', class: 'tab-item-component'
    end

    it 'with full parameters' do
      render_inline(described_class.new(item: 'two', path: test_url, options: full_params))

      expect(page).to have_link href: test_url
      expect(page).to have_text '5'
      expect(page).to have_css 'a#two', class: 'tab-component'
      expect(page).not_to have_css 'a#two', class: 'tab-item-component'
    end
  end
end
