class CreateCatsProdsAssociations < ActiveRecord::Migration[7.1]
  def change
    create_table :cats_prods_associations do |t|
      t.references :category, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
