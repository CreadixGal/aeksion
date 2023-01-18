# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DateSearcherComponent, type: :component do
  it 'renders searcher form' do
    render_inline(described_class.new(
                    path: 'search_movements_path',
                    attribute: 'range',
                    options: {
                      placeholder: 'search dates',
                      range: '27-12-2022 a 04-01-2023'
                    }
                  ))
    expect(page).to have_css 'form.search-form-component'
  end
end
