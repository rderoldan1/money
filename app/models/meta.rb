# == Schema Information
#
# Table name: meta
#
#  id             :integer          not null, primary key
#  descriptor     :string(255)
#  transaction_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Meta < ActiveRecord::Base
  attr_accessible :descriptor, :transaction_id

  validates :descriptor, :presence => true

end
