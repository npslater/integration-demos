require 'spec_helper'

describe "line_items/edit" do
  before(:each) do
    @line_item = assign(:line_item, stub_model(LineItem,
      :order_id => 1,
      :description => "MyString",
      :quantity => 1
    ))
  end

  it "renders the edit line_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => line_items_path(@line_item), :method => "post" do
      assert_select "input#line_item_order_id", :name => "line_item[order_id]"
      assert_select "input#line_item_description", :name => "line_item[description]"
      assert_select "input#line_item_quantity", :name => "line_item[quantity]"
    end
  end
end
