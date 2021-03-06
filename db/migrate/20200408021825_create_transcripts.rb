class CreateTranscripts < ActiveRecord::Migration[6.0]
  def change
    create_table :transcripts do |t|
      t.bigint :request_id
      t.string :status
      t.integer :character_count
      t.text :summary

      t.timestamps

      t.index :request_id
      t.index :created_at
    end
  end
end
