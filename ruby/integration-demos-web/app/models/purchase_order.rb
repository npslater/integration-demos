class PurchaseOrder < ActiveRecord::Base
  attr_accessible :created_by, :created_on, :status
  has_many :line_items, :foreign_key => 'order_id'
end
