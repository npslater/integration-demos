class LineItem < ActiveRecord::Base
  attr_accessible :description, :order_id, :quantity
  belongs_to :purchase_order, :class_name => 'PurchaseOrder', :foreign_key => 'order_id'
end
