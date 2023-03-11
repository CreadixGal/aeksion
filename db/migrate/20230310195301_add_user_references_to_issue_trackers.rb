class AddUserReferencesToIssueTrackers < ActiveRecord::Migration[7.0]
  def change
    add_reference :issue_trackers, :user, null: false, foreign_key: true, type: :uuid
  end
end
