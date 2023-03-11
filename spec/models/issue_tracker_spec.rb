require 'rails_helper'

RSpec.describe IssueTracker do
  subject { build(:issue_tracker, :with_image) }

  describe 'with required fields' do
    it 'must contain title' do
      pending 'work in progress'
      expect(subject.title).not_to be_empty
    end

    it 'title must be between 10 and 100 characters' do
      pending 'work in progress'
      expect(subject.title.length).to be_between(10, 100)
    end

    it 'title has validation error' do
      pending 'work in progress'
      subject.title = ''
      expect(subject).not_to be_valid
    end

    it 'description has validation error' do
      pending 'work in progress'
      subject.description = ''
      expect(subject).not_to be_valid
    end

    it 'title has a custom validation error message' do
      pending 'work in progress'
      subject.title = 'hello'
      expect(subject).not_to be_valid
    end
  end

  describe 'with optional file' do
    it 'image is an ActiveStorage::Attached::Many' do
      pending 'work in progress'
      expect(subject.images).to be_a(ActiveStorage::Attached::Many)
    end
  end
end
