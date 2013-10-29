require 'spec_helper'

describe "purchase_orders/new" do
  before(:each) do
    assign(:purchase_order, stub_model(PurchaseOrder,
      :status => "MyString",
      :created_by => "MyString"
    ).as_new_record)
  end

  it "renders new purchase_order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => purchase_orders_path, :method => "post" do
      assert_select "input#purchase_order_status", :name => "purchase_order[status]"
      assert_select "input#purchase_order_created_by", :name => "purchase_order[created_by]"
    end
  end
end
