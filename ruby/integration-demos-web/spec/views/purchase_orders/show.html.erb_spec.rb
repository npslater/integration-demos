require 'spec_helper'

describe "purchase_orders/show" do
  before(:each) do
    @purchase_order = assign(:purchase_order, stub_model(PurchaseOrder,
      :status => "Status",
      :created_by => "Created By"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Status/)
    rendered.should match(/Created By/)
  end
end
