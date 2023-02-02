# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationStatusComponent, type: :component do
  it 'renders pending circle red' do
    render_inline(described_class.new(status: 'pending'))
    expect(page).to have_css 'span.absolute', class: 'bg-red-500'
  end

  it 'renders viewed circle indigo' do
    render_inline(described_class.new(status: 'viewed'))
    expect(page).to have_css 'span.absolute', class: 'bg-indigo-500'
  end

  it 'renders in progress circle amber' do
    render_inline(described_class.new(status: 'in_progress'))
    expect(page).to have_css 'span.absolute', class: 'bg-amber-500'
  end

  it 'renders completed circle green' do
    render_inline(described_class.new(status: 'completed'))
    expect(page).to have_css 'span.absolute', class: 'bg-green-500'
  end

  it 'renders pending circle red whit text white' do
    render_inline(described_class.new(status: 'pending', count: 3))
    expect(page).to have_text '3'
    expect(page).to have_css 'span.absolute', class: 'bg-red-500'
  end
end
