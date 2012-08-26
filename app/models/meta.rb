# == Schema Information
#
# Table name: meta
#
#  id             :integer          not null, primary key
#  descriptor     :string(255)
#  transaction_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  note           :text
#

class Meta < ActiveRecord::Base
  attr_accessible :descriptor, :transaction, :note
  belongs_to :transaction

  validates :descriptor, :presence => true
  validates :transaction, :presence => true

end
