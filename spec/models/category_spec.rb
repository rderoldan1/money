# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Category do

  before do
    @c = Category.new( name: 'Something' )
  end

  subject { @c }

  it { should respond_to(:name) }

  describe "Invalid name" do

    it "is empty" do
      @c.name = ''
      @c.should_not be_valid
    end

  end

end
