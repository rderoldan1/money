class AddCreditCardFieldsToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :trans_date, :datetime
    add_column :transactions, :trans_type, :string
  end
end
