# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationComponent, type: :component do
  it 'renders success notification' do
    render_inline(described_class.new(type: 'success', data: 'Success message!'))
    expect(page).to have_text 'Success message!'
    expect(page).to have_css 'div.border-t-green-400', class: 'border-t-green-400'
  end

  it 'renders error notification' do
    render_inline(described_class.new(type: 'error', data: 'Error message!'))
    expect(page).to have_text 'Error message!'
    expect(page).to have_css 'div.border-t-red-500', class: 'border-t-red-500'
  end

  it 'renders alert notification' do
    render_inline(described_class.new(type: 'alert', data: 'Alert message!'))
    expect(page).to have_text 'Alert message!'
    expect(page).to have_css 'div.border-t-orange-500', class: 'border-t-orange-500'
  end

  it 'renders info notification' do
    render_inline(described_class.new(type: 'info', data: 'Info message!'))
    expect(page).to have_text 'Info message!'
    expect(page).to have_css 'div.border-t-indigo-400', class: 'border-t-indigo-400'
  end

  it 'renders default notification' do
    render_inline(described_class.new(type: 'default', data: 'Default message!'))
    expect(page).to have_text 'Default message!'
    expect(page).to have_css 'div.border-t-blue-400', class: 'border-t-blue-400'
  end

  # rubocop:disable Layout/LineLength
  it 'renders notification with data' do
    render_inline(described_class.new(type: 'success', data: { title: 'Success message!', body: 'This is a success message!' }))
    expect(page).to have_text 'Success message!'
    expect(page).to have_text 'This is a success message!'
  end
  # rubocop:enable Layout/LineLength
end
