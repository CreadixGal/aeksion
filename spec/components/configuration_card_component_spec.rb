# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConfigurationCardComponent, type: :component do
  let(:required_params) do 
    {
      title: 'Clientes', 
      options: {
        href_1: 'www.example.com',
      }
    }
  end

  let(:full_params) do
    {
      icon: 'user-group.svg',
      link_1: 'Ver clientes',
      href_1: 'www.example.com',
      link_2: 'Crear cliente',
      href_2: 'www.example.com/test',
    }
  end

  it 'renders default configuration card component' do
    render_inline(described_class.new(title: required_params[:title], description: required_params[:description], options: required_params[:options]))

    expect(page).to have_content required_params[:title]
    expect(page).to have_content 'Consultar, editar y eliminar clientes'
    expect(page).to have_content 'Consultar'
    expect(page).to have_link href: required_params[:options][:href_1]
  end

  it 'renders configuration card component with full params' do
    options = required_params
    options = options.merge(description: 'Random description', options: full_params)

    render_inline(described_class.new(title: options[:title], description: options[:description] , options: options[:options]))

    expect(page).to have_content options[:title]
    expect(page).to have_content 'Random description'
    expect(page).to have_content 'Ver clientes'
    expect(page).to have_link href: options[:options][:href_1]
    expect(page).to have_content 'Crear cliente'
    expect(page).to have_link href: options[:options][:href_2]
  end
end
