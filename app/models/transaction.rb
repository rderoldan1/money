# == Schema Information
#
# Table name: transactions
#
#  id           :integer          not null, primary key
#  date         :datetime
#  check_number :string(255)
#  description  :string(255)
#  debit        :float
#  credit       :float
#  sha1_digest  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  bank_id      :integer
#  trans_date   :datetime
#  trans_type   :string(255)
#

class Transaction < ActiveRecord::Base
  attr_accessible :check_number, :credit, :date, :debit, :description, :sha1_digest, :bank_id, :trans_date, :trans_type
  belongs_to :bank
  has_one :meta

  validates :date, :presence => true
  validates :description, :presence => true
  validates :sha1_digest, :presence => true, :length => { :is => 40 }, :uniqueness => true

end
