class CreateIssueTrackers < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_trackers, id: :uuid do |t|
      t.string :title, null: false
      t.string :status, null: false, default: 'pending'
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
