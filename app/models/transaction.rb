# == Schema Information
#
# Table name: transactions
#
#  id                :integer          not null, primary key
#  date              :datetime
#  check_number      :string(255)
#  description       :string(255)
#  description_clean :string(255)
#  debit             :float
#  credit            :float
#  sha1_digest       :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  bank_id           :integer
#  trans_date        :datetime
#  trans_type        :string(255)
#

class Transaction < ActiveRecord::Base
  before_validation :clean

  attr_accessible :check_number, :credit, :date, :debit, :description, :sha1_digest, :bank_id, :trans_date, :trans_type

  belongs_to :bank
  has_one :meta

  validates :date, :presence => true
  validates :description, :presence => true
  validates :sha1_digest, :presence => true, :length => { :is => 40 }, :uniqueness => true

  # campare debit vs credit and return a value
  def amount
    self.debit.nil? ? self.credit : -self.debit
  end

  def suggest

    # only suggest if a suggestion hasn't been set
    if self.meta.nil?
      m = Transaction.joins(:meta).where("transactions.description_clean like ? and meta.descriptor != ''", '%' + self.description_clean + '%').select("meta.descriptor").limit(1)[0]

      m.nil? ? '' : m.descriptor 
    else

      self.meta.descriptor

    end

  end

  private
    def clean
      self.description_clean = self.description.gsub(/[^A-z ]/, '')
                                               .gsub(/ [ ]+/, ' ')
    end

end
