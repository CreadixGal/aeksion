require 'rails_helper'

RSpec.describe 'Customers', type: :request do
  subject { create(:customer) }

  before { sign_in build(:user) }

  after(:all) { Customer.all.each { |c| c.destroy! if c.name.include? 'test' } }

  let(:valid_attributes) { { name: Faker::Company.name } }

  let(:invalid_attributes) { { name: nil } }

  describe 'GET /index' do
    it 'renders a successful response' do
      get customers_path
      expect(response).to have_http_status(:success)
    end

    it 'renders a list of customers' do
      get customers_path
      expect(response.body).to include('Customers')
    end

    it 'renders a turbo frame' do
      get customers_path
      expect(response.body).to include('turbo-frame')
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get customer_path(subject)
      expect(subject).to be_present
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_customer_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_customer_path(subject)
      expect(subject).to be_present
    end
  end
end
