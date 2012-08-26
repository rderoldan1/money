class CreateMeta < ActiveRecord::Migration
  def change
    create_table :meta do |t|
      t.string :descriptor
      t.integer :transaction_id

      t.timestamps
    end
  end
end
