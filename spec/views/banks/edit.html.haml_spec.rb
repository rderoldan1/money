require 'spec_helper'

describe "banks/edit" do
  before(:each) do
    @bank = assign(:bank, stub_model(Bank,
      :name => "MyString"
    ))
  end

  it "renders the edit bank form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => banks_path(@bank), :method => "post" do
      assert_select "input#bank_name", :name => "bank[name]"
    end
  end
end
