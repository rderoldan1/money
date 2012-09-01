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

  def self.amounts( opt = {} )

    require 'date'

    opt.reverse_merge!({
      :type    => 'credit'       , 
      :like    => []             , 
      :unlike  => []             , 
      :bank    => Bank.first.id
    })

    m = opt[:month].to_s
    date_format = nil

    valid_dates = {
      /^[0-9]{4}\-[0-9]{1,2}$/ => '%Y-%m' ,
      /^[0-9]{4}$/             => '%Y' ,
      /^[0-9]{1,2}$/           => '%m' ,
    }

    valid_dates.each do |r, f| 
      if r =~ m && true 
        date_format = f
        break
      end
    end

    month = date_format.nil? || ( m.to_i > 12 && m.to_i < 1000 ) ? Time.now : Date.strptime( m, date_format )

    beginning = month.strftime('%Y-%m-%d')
    ending    = month.end_of_month.strftime("%Y-%m-%d")

    if m == '-1'
      beginning = '1950-01-01'
      ending    = Date.today.end_of_month.strftime("%Y-%m-%d")
    end

    like = [] 
    opt[:like].each { |d| like << "lower(meta.descriptor) like '%#{d}%'" }
    like = like.join " or "

    unlike = [] 
    opt[:unlike].each { |d| unlike << "lower(meta.descriptor) like '%#{d}%'" }
    unlike = unlike.join " or "

    where = "
          #{opt[:type]} is not null
      and transactions.date between \"#{beginning}\" and \"#{ending}\"
    "

    if !like.empty?
      where += "and ( #{like} )"
    end

    if !unlike.empty?
      where += "and not ( #{unlike} )"
    end

    Transaction.where(:bank_id => opt[:bank]).joins(:meta).where(where).group("meta.descriptor").order("transactions.#{opt[:type]} DESC").sum("transactions.#{opt[:type]}")

  end 

  def self.giving( month )
    self.amounts :month => month, :type => 'debit', :bank => 1, :like => %w"support mission tithe"
  end

  def self.income( month)
    Transaction.amounts :month => month, :type => 'credit', :bank => 1, :like => %w"ve ssm" + ['new constructs']
  end

  def self.giving_total( month )
    giving = self.giving( month )
    giving_total = 0
    if ! giving.nil?
      giving.each {|k, v| giving_total += v }
    end
    giving_total
  end

  def self.income_total( month )
    income = self.income( month )
    income_total = 0
    if ! income.nil?
      income.each {|k, v| income_total += v }
    end
    income_total
  end

  def self.tithe( month )
    giving_total = self.giving_total( month )
    income_total = self.income_total( month )

    -income_total * 0.1 + giving_total
  end

  private
    def clean
      self.description_clean = self.description.gsub(/[^A-z ]/, '')
                                               .gsub(/ [ ]+/, ' ')
    end

end
