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

require 'spec_helper'

describe Meta do

  before do
    @m = Meta.new( descriptor: 'Something' )
  end

  subject { @m }

  it { should respond_to(:descriptor) }

  describe "Invalid descriptor" do

    it "is empty" do
      @m.descriptor = ''
      @m.should_not be_valid
    end

  end

end
