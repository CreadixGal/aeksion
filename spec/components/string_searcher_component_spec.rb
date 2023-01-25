# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StringSearcherComponent, type: :component do
  it 'renders searcher form' do
    render_inline(described_class.new(
                    path: 'search_customers_url',
                    attribute: 'name',
                    options: {
                      placeholder: 'search customer',
                      regex: Faker::Name.name
                    }
                  ))
    expect(page).to have_css 'form.search-form-component'
  end
end
