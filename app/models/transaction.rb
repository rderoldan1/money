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

  def company_suggest

    # only suggest if a suggestion hasn't been set
    if self.meta.nil? 
      m = Transaction.joins(:meta).where("transactions.description_clean like ? and meta.descriptor != ''", '%' + self.description_clean + '%').select("meta.company").limit(1)[0]

      m.nil? ? '' : m.company 

    elsif self.meta.company.empty?

      m = Transaction.joins(:meta).where("transactions.description_clean like ? and meta.company != ''", '%' + self.description_clean + '%').select("meta.company").limit(1)[0]

      m.nil? ? '' : m.company 

    else

      self.meta.company

    end

  end

  def self.amounts( opt = {} )

    opt.reverse_merge!({
      :type    => 'credit'       , 
      :equal   => []             , 
      :like    => []             , 
      :unlike  => []             , 
      :bank    => Bank.first.id
    })

    where = create_where opt 

    Transaction.where(:bank_id => opt[:bank]).joins(:meta).where(where).group("meta.descriptor").order("transactions.#{opt[:type]} DESC").sum("transactions.#{opt[:type]}")

  end 

  def self.items( opt = {} )

    opt.reverse_merge!({
      :type    => 'credit'       , 
      :equal   => []             , 
      :like    => []             , 
      :unlike  => []             , 
      :bank    => Bank.first.id
    })

    where = create_where opt 

    Transaction.where(:bank_id => opt[:bank] ).joins(:meta).where(where)

  end

  def self.giving( month )
    self.amounts :month => month, :type => 'debit', :bank => 1, :like => %w"support mission tithe"
  end

  def self.income( month)
    income = self.amounts :month => month, :type => 'credit', :bank => 1, :like => %w"ve ssm" + ['new constructs']
    income.sort_by {|k,v| v}.reverse
  end

  def self.expense( month)
    expense = amounts :month => month, :type => 'debit', :bank => [1, 2] , :unlike => %w"transfer" + ['credit card payment', 'cash withdr']
    expense.sort_by {|k,v| v}.reverse
  end

  def self.giving_total( month )
    giving = giving month
    total giving
  end

  def self.income_total( month )
    income = income month
    total income
  end

  def self.expense_total( month )
    expense = expense month
    total expense
  end

  def self.total( type )
    type_total = 0
    if ! type.nil?
      type.each {|k, v| type_total += v }
    end
    type_total
  end

  def self.tithe( month )
    giving_total = giving_total month 
    income_total = income_total month 

    -income_total * 0.1 + giving_total
  end

  def self.format_date m

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

    date_format.nil? || ( m.to_i > 12 && m.to_i < 1000 ) ? Time.now : Date.strptime( m, date_format )

  end


  private
    def clean
      self.description_clean = self.description.gsub(/[^A-z ]/, '')
                                               .gsub(/ [ ]+/, ' ')
    end

    def self.create_where( opt = {})
      require 'date'

      opt.reverse_merge!({
        :type    => 'credit'       , 
        :equal   => []             , 
        :like    => []             , 
        :unlike  => []             , 
        :bank    => Bank.first.id 
      })

      m = opt[:month].to_s

      month = format_date m

      beginning = month.strftime('%Y-%m-%d')
      ending    = month.end_of_month.strftime("%Y-%m-%d")

      if m == '-1'
        beginning = '1950-01-01'
        ending    = Date.today.end_of_month.strftime("%Y-%m-%d")
      end

      equal = [] 
      opt[:equal].each { |d| equal << "meta.descriptor = '#{d}'" }
      equal = equal.join " or "

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

      if !equal.empty?
        where += "and ( #{equal} )"
      end

      if !like.empty?
        where += "and ( #{like} )"
      end

      if !unlike.empty?
        where += "and not ( #{unlike} )"
      end

      where
    end


end
