class UpdateOrderStatusColumn < ActiveRecord::Migration[7.1]
  def change
    change_column :orders, :order_status, :string, default:'placed'
  end
end
