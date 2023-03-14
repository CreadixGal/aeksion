require 'rails_helper'

RSpec.describe IssueTracker do
  let(:issue) { build(:issue_tracker) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many_attached(:images) }
    it { is_expected.to accept_nested_attributes_for(:comments) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }

    it 'validates the length of the title' do
      issue = described_class.new(title: 'a' * 9)
      expect(issue).not_to be_valid

      issue = described_class.new(title: 'a' * 101)
      expect(issue).not_to be_valid

      issue = described_class.new(title: nil)
      expect(issue).not_to be_valid
      expect(issue.errors[:title].first).to include('no puede estar en blanco')
    end

    it { is_expected.to validate_presence_of(:comments) }
  end

  describe 'enums' do
    it 'defines the status enum with the correct values and default' do
      expect(described_class.statuses.keys).to eq(%w[pending viewed in_progress completed])
      expect(issue.status).to eq('pending')
    end
  end

  describe 'scopes' do
    describe '.ordered' do
      it 'orders by created_at in descending order' do
        issue1 = create(:issue_tracker, created_at: 1.day.ago)
        issue2 = create(:issue_tracker)
        issue3 = create(:issue_tracker, created_at: 2.days.ago)

        expect(described_class.ordered).to eq [issue2, issue1, issue3]
      end
    end

    describe '.pending_count' do
      it 'returns the count of pending issues' do
        create(:issue_tracker, status: :pending)
        create(:issue_tracker, status: :viewed)

        expect(described_class.pending_count).to eq 1
      end
    end
  end
end
