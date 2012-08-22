class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.datetime :date
      t.string :check_number
      t.string :description
      t.float :debit
      t.float :credit

      t.timestamps
    end
  end
end
