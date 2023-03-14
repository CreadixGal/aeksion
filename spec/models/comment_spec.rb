RSpec.describe Comment do
  let(:user) { create(:user) }
  let(:commentable) { create(:issue_tracker) }

  it 'has a valid factory' do
    comment = build(:comment, user:, commentable:)
    expect(comment).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:commentable) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_least(20) }
  end
end
