class AddBankToTransaction < ActiveRecord::Migration
  def up
    add_column :bank_transactions, :bank_id, :integer
  end
  def down
    remove_column :bank_transactions, :bank_id
  end
end
