require 'rails_helper'

RSpec.describe 'Customers', type: :request do
  subject { create(:customer) }

  before { sign_in build(:user) }

  after(:all) { Customer.all.each { |c| c.destroy! if c.name.include? 'test_' } }

  let(:valid_attributes) { { name: "test_#{Faker::Company.name}" } }

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

  describe 'POST /search' do
    it 'renders a successful media type response' do
      pending 'IDK how to test turbo stream 😠😠😠'
      post search_customers_path, params: { name: subject.name }
      # rubocop:disable Layout/LineLength
      expect(response.body).to include('flex justify-start my-2 p-2  hover:text-blue-500 dark:text-gray-800 dark:hover:text-gray-300 bg-yellow-300 dark:hover:bg-gray-700 hover:bg-indigo-50 rounded-xl hover:cursor-pointer')
      # rubocop:enable Layout/LineLength
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get customer_path(subject)
      expect(response).to have_http_status(:success)
    end

    it 'subject is present' do
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

  describe 'POST /create' do
    it 'creates a new Customer' do
      post customers_path, params: { customer: valid_attributes }
      expect(Customer.last.name).to eq(valid_attributes[:name])
    end

    it 'renders a successful response' do
      post customers_path, params: { customer: valid_attributes }
      expect(response).to have_http_status(:redirect)
    end

    it 'increment by 1 the number of customers' do
      expect do
        post customers_path, params: { customer: valid_attributes }
      end.to change(Customer, :count).by(1)
    end

    context 'with invalid parameters' do
      it 'does not create a new Customer' do
        expect do
          post customers_path, params: { customer: invalid_attributes }
        end.not_to change(Customer, :count)
      end

      it 'renders customers new form' do
        post customers_path, params: { customer: invalid_attributes }
        expect(response.body).to include('form')
      end
    end
  end

  describe 'PATCH /update' do
    it 'updates the requested customer' do
      patch customer_path(subject), params: { customer: valid_attributes }
      expect(subject.reload.name).to eq(valid_attributes[:name])
    end

    it 'renders a successful response' do
      patch customer_path(subject), params: { customer: valid_attributes }
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to the customers index' do
      patch customer_path(subject), params: { customer: valid_attributes }
      expect(response).to redirect_to(customers_path)
    end

    context 'with invalid parameters' do
      it 'renders customers edit form' do
        patch customer_path(subject), params: { customer: invalid_attributes }
        expect(response.body).to include('form')
      end

      it 'does not update the requested customer' do
        patch customer_path(subject), params: { customer: invalid_attributes }
        expect(subject.reload.name).not_to eq(invalid_attributes[:name])
      end

      it 'renders error notification' do
        patch customer_path(subject), params: { customer: invalid_attributes }
        expect(response.body).to include('error')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deleted requested customer' do
      delete customer_path(subject)
      expect { subject.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'renders a successful response' do
      delete customer_path(subject)
      expect(response).to have_http_status(:redirect)
    end

    it 'redirects to the customers index' do
      delete customer_path(subject)
      expect(response).to redirect_to(customers_path)
    end
  end

  describe 'DELETE /multiple_delete' do
    it 'redirects to customers path' do
      delete multiple_delete_customers_path, params: { ids: [] }
      expect(response).to redirect_to(customers_path)
    end

    it 'redirects to the customers index' do
      pending 'Bullet::Notification::UnoptimizedQueryError:
      user: cisco
      DELETE /zones/multiple_delete
      USE eager loading detected
        Zone => [:rates]
        Add to your query: .includes([:rates])'
      customer1 = create(:customer)
      customer2 = create(:customer)
      delete multiple_delete_customers_path, params: { customer_ids: [customer1.id, customer2.id] }
      expect(response).to redirect_to(customers_path)
    end
  end
end
