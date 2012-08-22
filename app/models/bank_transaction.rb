class BankTransaction < ActiveRecord::Base
  attr_accessible :check_number, :credit, :date, :debit, :description, :sha1_digest

  validates :date, :presence => true
  validates :description, :presence => true
  validates :sha1_digest, :presence => true, :length => { :is => 40 }, :uniqueness => true

end
