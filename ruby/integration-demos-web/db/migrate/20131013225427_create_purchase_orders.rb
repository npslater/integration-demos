class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.string :status
      t.datetime :created_on
      t.string :created_by

      t.timestamps
    end
  end
end
