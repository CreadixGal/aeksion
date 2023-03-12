require 'rails_helper'

RSpec.describe 'IssueTrackers' do
  subject { create(:user) }

  before { sign_in subject }

  describe 'GET /issue_trackers' do
    it 'returns http success' do
      get issue_trackers_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /issue_trackers/new' do
    it 'returns http success' do
      get new_issue_tracker_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /issue_trackers' do
    it 'creates a new issue tracker' do
      issue = build(:issue_tracker, :with_image)
      post  issue_trackers_path,
            params: {
              issue_tracker: {
                title: issue.title,
                description: issue.description,
                images: issue.images.first
              }
            }
      expect(response).to have_http_status(:found)
    end

    it 'creates a new issue tracker without image and modifies count by 1' do
      issue = build(:issue_tracker)
      expect do
        post  issue_trackers_path,
              params: {
                issue_tracker: {
                  title: issue.title,
                  description: issue.description
                }
              }
      end.to change(IssueTracker, :count).by(1)
    end
  end
end
