class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.string :name
      t.string :requestable_type
      t.bigint :requestable_id

      t.timestamps

      t.index :created_at
      t.index [:requestable_type, :requestable_id]
    end
  end
end
