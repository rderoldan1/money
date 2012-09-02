class AddCompanyToMeta < ActiveRecord::Migration
  def change
    add_column :meta, :company, :string, :after => :transaction_id
  end
end
