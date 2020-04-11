class CreateGuests < ActiveRecord::Migration[6.0]
  def change
    create_table :guests do |t|
      t.string :session_id, null: false

      t.timestamps

      t.index :created_at
      t.index :session_id, unique: true
    end
  end
end
