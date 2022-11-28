require 'rails_helper'

RSpec.describe 'Movements', type: :request do
  subject { create(:movement) }

  before { sign_in build(:user) }
end