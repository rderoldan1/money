class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.datetime :date
      t.string :check_number
      t.string :description
      t.float :debit
      t.float :credit
      t.string :sha1_digest

      t.timestamps
    end
  end
end
