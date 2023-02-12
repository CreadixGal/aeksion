class CreateIssueTrackers < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_trackers, id: :uuid do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :status, null: false, default: 'pending'
      t.timestamps
    end
  end
end