require 'rails_helper'

RSpec.describe RatesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/rates').to route_to('rates#index')
    end

    it 'routes to #new' do
      expect(get: '/rates/new').to route_to('rates#new')
    end

    it 'routes to #show' do
      expect(get: '/rates/1').to route_to('rates#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/rates/1/edit').to route_to('rates#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/rates').to route_to('rates#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/rates/1').to route_to('rates#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/rates/1').to route_to('rates#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/rates/1').to route_to('rates#destroy', id: '1')
    end
  end
end
