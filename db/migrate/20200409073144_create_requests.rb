class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.string :name

      t.timestamps

      t.index :created_at
    end
  end
end
