# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModalComponent, type: :component do
  it 'renders modal' do
    render_inline(described_class.new(title: 'Hello World'))
    expect(page).to have_text 'Hello World'
  end

  it 'renders modal with custom classes' do
    render_inline(described_class.new(title: 'Hello World'))
    expect(page).to have_css 'div.modal', class: 'modal'
  end

  it 'renders modal inside a turbo frame' do
    render_inline(described_class.new(title: 'Hello World'))
    expect(page).to have_css 'turbo-frame#modal'
  end
end
