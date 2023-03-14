require 'rails_helper'

RSpec.describe 'IssueTrackers' do
  subject { create(:user) }

  before { sign_in subject }

  let(:issue) { create(:issue_tracker) }

  let(:valid_attributes) do
    {
      issue_tracker: {
        title: 'Issue title',
        comment: {
          body: 'Issue body comment test',
          user_id: subject.id
        }
      }
    }
  end

  describe 'GET /issue_trackers' do
    it 'renders the index template' do
      get issue_trackers_path
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /issue_trackers/:id' do
    it 'renders the show template' do
      get issue_tracker_path(issue)
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)
    end

    it 'marks the issue as viewed if it is pending' do
      expect(issue.pending?).to be(true)
      get issue_tracker_path(issue)
      expect(issue.reload.viewed?).to be(true)
    end
  end

  describe 'GET /issue_trackers/new' do
    it 'renders the new template' do
      get new_issue_tracker_path
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /issue_trackers/:id/edit' do
    it 'renders the edit template' do
      get edit_issue_tracker_path(issue)
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /issue_trackers' do
    it 'creates a new issue_tracker' do
      expect do
        post issue_trackers_path, params: valid_attributes
      end.to change(IssueTracker, :count).by(1)

      expect(response).to redirect_to(issue_trackers_path)
      expect(flash[:success]).to eq('Issue tracker was successfully created.')
    end
  end

  describe 'PUT /issue_trackers/:id' do
    context 'with valid params' do
      it 'updates the issue_tracker' do
        user = create(:user)
        issue = create(:issue_tracker)

        comment_params = {
          comment: {
            body: 'Response with a new comment to original issue',
            user_id: user.id
          }
        }

        expect do
          put issue_tracker_path(issue), params: { issue_tracker: comment_params }
        end.to change(issue.comments, :count).by(1)

        expect(response).to redirect_to(issue_trackers_path)
        expect(flash[:success]).to eq('Issue tracker was successfully updated.')
      end
    end
  end
end
