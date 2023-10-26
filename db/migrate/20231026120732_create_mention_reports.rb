class CreateMentionReports < ActiveRecord::Migration[7.0]
  def change
    create_table :mention_reports do |t|
      t.references :report, foreign_key: true
      t.references :mentioned_report, foreign_key: { to_table: :reports }
      t.index %i[report_id mentioned_report_id], unique: true

      t.timestamps
    end
  end
end
