class CreateTranscripts < ActiveRecord::Migration[6.0]
  def change
    create_table :transcripts do |t|
      t.bigint :request_id

      t.timestamps
    end
  end
end
