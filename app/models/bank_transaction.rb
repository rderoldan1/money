class BankTransaction < ActiveRecord::Base
  attr_accessible :check_number, :credit, :date, :debit, :description
end
