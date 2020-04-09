class CreateAudios < ActiveRecord::Migration[6.0]
  def change
    create_table :audios do |t|
      t.bigint :transcript_id
      t.string :filename
      t.string :codec
      t.integer :duration

      t.timestamps
    end
  end
end
