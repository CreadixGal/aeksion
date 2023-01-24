# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckboxComponent, type: :component do
  let(:full_options) do
    {
      value: 'Hola mundo',
      action: 'checkAll',
      target: 'parent',
      input_style: 'form-check-input appearance-none h-6 w-6 bg-white',
      display_label: true
    }
  end

  it 'with default paramaeters' do
    render_inline(described_class.new(id: 'default', name: 'components[]'))

    expect(page).to have_selector 'input[data-checkbox-select-all-target="child"]'
    expect(page).to have_selector 'input[data-action="click->checkbox-select-all#checkParent"]'
    expect(page).to have_selector 'input[type="checkbox"]'
    expect(page).to have_selector 'input[class="checkbox-input"]'
    expect(page).to have_css      'input#default', class: 'checkbox-input'
  end

  it 'with full parameters' do
    render_inline(described_class.new(id: 'component', name: 'components[]', options: full_options))

    expect(page).to     have_text     'Seleccionar todos'
    expect(page).to     have_selector 'input[data-checkbox-select-all-target="parent"]'
    expect(page).to     have_selector 'input[data-action="click->checkbox-select-all#checkAll"]'
    expect(page).to     have_selector 'input[type="checkbox"]'
    expect(page).to     have_selector 'input[value="Hola mundo"]'
    expect(page).to     have_css      'input#component', class: full_options[:input_style]
    expect(page).not_to have_selector 'input[class="checkbox-input"]'
    expect(page).not_to have_css      'input#default', class: 'checkbox-input'
  end
end
