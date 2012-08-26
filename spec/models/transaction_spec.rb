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

require 'spec_helper'
require 'digest'
require 'date'

describe Transaction do

  before do
    fingerprint = Digest::SHA1::hexdigest "a"
    @t = Transaction.new( date: Time.now, description: 'Some', sha1_digest: fingerprint ) 
  end

  subject { @t }

  it { should respond_to(:date) }
  it { should respond_to(:description) }
  it { should respond_to(:sha1_digest) }

  describe "invalid fingerprint" do

    it "not long enough" do
      @t.sha1_digest = 'a'
      @t.should_not be_valid
    end

    it "too long" do
      @t.sha1_digest = 'a' * 41
      @t.should_not be_valid
    end

    it "not present" do
      @t.sha1_digest = ''
      @t.should_not be_valid
    end

    it 'not unique' do 
      dup = @t.dup
      dup.save

      should_not be_valid

    end

  end

  describe "invalid date" do

    it 'not present' do
      @t.date = nil
      @t.should_not be_valid
    end

  end

  describe "invalid description" do

    it 'not present' do
      @t.description = ''
      @t.should_not be_valid
    end

  end

end
