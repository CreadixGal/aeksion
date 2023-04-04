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
    it { should define_enum_for(:status).with_values(pending: 'pending', viewed: 'viewed', in_progress: 'in_progress', completed: 'completed').backed_by_column_of_type(:string) }
  end

  describe 'scopes' do
    let!(:user) { create(:user) }
    let!(:issue_tracker_1) { create(:issue_tracker, user: user, status: :pending) }
    let!(:issue_tracker_2) { create(:issue_tracker, user: user, status: :viewed) }

    context 'ordered' do
      it 'returns issues in descending order of creation' do
        expect(IssueTracker.ordered).to eq([issue_tracker_2, issue_tracker_1])
      end
    end

    context 'pending_count' do
      it 'returns the count of pending issues' do
        expect(IssueTracker.pending_count).to eq(1)
      end
    end
  end
end
