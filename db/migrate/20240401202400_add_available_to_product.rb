class AddAvailableToProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :available, :boolean, default: true, null: false
  end
end
