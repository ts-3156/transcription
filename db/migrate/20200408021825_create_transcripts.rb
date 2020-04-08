class CreateTranscripts < ActiveRecord::Migration[6.0]
  def change
    create_table :transcripts do |t|
      t.string :name
      t.integer :duration

      t.timestamps
    end
  end
end
