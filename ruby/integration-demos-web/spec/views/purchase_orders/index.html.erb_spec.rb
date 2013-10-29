require 'spec_helper'

describe "purchase_orders/index" do
  before(:each) do
    assign(:purchase_orders, [
      stub_model(PurchaseOrder,
        :status => "Status",
        :created_by => "Created By"
      ),
      stub_model(PurchaseOrder,
        :status => "Status",
        :created_by => "Created By"
      )
    ])
  end

  it "renders a list of purchase_orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Created By".to_s, :count => 2
  end
end
