class Category < ApplicationRecord
  has_many :cats_prods_associations
  has_many :products, through: :cats_prods_associations, dependent: :destroy
end
