# == Schema Information
#
# Table name: banks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Bank do

  before do
    @b = Bank.new( name: 'Something' )
  end

  subject { @b }

  it { should respond_to(:name) }

  describe "Invalid name" do

    it "is empty" do
      @b.name = ''
      @b.should_not be_valid
    end

  end

end
