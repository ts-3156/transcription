class CreateAudios < ActiveRecord::Migration[6.0]
  def change
    create_table :audios do |t|
      t.bigint :request_id
      t.string :filename
      t.string :codec
      t.integer :duration

      t.timestamps

      t.index :request_id
      t.index :created_at
    end
  end
end
