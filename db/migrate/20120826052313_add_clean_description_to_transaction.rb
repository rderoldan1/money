class AddCleanDescriptionToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :description_clean, :string, :after => :description
  end
end
