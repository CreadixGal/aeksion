class RemoveDescriptionFromIssueTracker < ActiveRecord::Migration[7.0]
  def change
    remove_column :issue_trackers, :description, :text
  end
end
