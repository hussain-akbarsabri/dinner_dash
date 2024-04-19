# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Category.destroy_all
CatsProdsAssociation.destroy_all
Product.destroy_all
Cart.destroy_all
Order.destroy_all

Category.create(:title => "Breakfast")
Category.create(:title => "Casual Dining")
Category.create(:title => "Fast Food")
Category.create(:title => "Buffet")
Category.create(:title => "Ghar ka khana")


# PRODUCT
size=20
Products = Array.new(size)
Titles = ["Egg McMuffin","Bread","Cheese","Milk", "CHILLI CRAB","CURRY FEAST","Roti Paratha", "BEEF RENDANG","BEEF NOODLES","Biryani","Nihari","Kabuli Pulao","Karahi", "Haleem","Mutton Korma","Tikka Kebab","Sajji", "Whopper","Cheeseburger","Pizza",]
Descriptions = ["xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz","xyz",]
Prices = [300,1300,500,200,100,50,600,800,1000,2000,500,300,300,200,100,150,120,2000,100,250,]

i=0
while i<size do
  Products[i] = Product.new(:title => Titles[i], :description => Descriptions[i], :price => Prices[i])
  i= i+1
end

# Create associations b/w products and categories
Products[0].categories<<Category.find_by(:title => "Breakfast")
Products[0].categories<<Category.find_by(:title => "Fast Food")
Products[1].categories<<Category.find_by(:title => "Breakfast")
Products[2].categories<<Category.find_by(:title => "Breakfast")
Products[3].categories<<Category.find_by(:title => "Casual Dining")
Products[4].categories<<Category.find_by(:title => "Casual Dining")
Products[5].categories<<Category.find_by(:title => "Casual Dining")
Products[6].categories<<Category.find_by(:title => "Casual Dining")
Products[7].categories<<Category.find_by(:title => "Buffet")
Products[8].categories<<Category.find_by(:title => "Buffet")
Products[9].categories<<Category.find_by(:title => "Buffet")
Products[10].categories<<Category.find_by(:title => "Buffet")
Products[11].categories<<Category.find_by(:title => "Buffet")
Products[12].categories<<Category.find_by(:title => "Ghar ka khana")
Products[13].categories<<Category.find_by(:title => "Ghar ka khana")
Products[14].categories<<Category.find_by(:title => "Ghar ka khana")
Products[15].categories<<Category.find_by(:title => "Ghar ka khana")
Products[16].categories<<Category.find_by(:title => "Ghar ka khana")
Products[17].categories<<Category.find_by(:title => "Fast Food")
Products[18].categories<<Category.find_by(:title => "Fast Food")
Products[19].categories<<Category.find_by(:title => "Fast Food")

Products.each do |p|
  p.save # to save cats
end

# Add images to products
ImageNames = ['egg_mcmuffin', 'bread', 'cheese', 'milk', 'chilli_crab', 'curry_feast', 'roti_paratha', 'beef_redeng', 'beef_noodles', 'biryani', 'nihari', 'kabuli_pulao', 'karahi', 'haleem', 'mutton_korma', 'tikka_kebab', 'sajji', 'whopper', 'cheeseburger', 'pizza']
i=0
while i<size do
  file = URI.open("https://res.cloudinary.com/dk7yhg9uz/products/#{ImageNames[i]}.jpg")
  Products[i].image.attach(io: file, filename: "#{ImageNames[i]}.jpg", content_type: 'image/jpg')
  i= i+1
end
# Note: use URI.open to open a remote file, (wasted 3 hours!)


user1 = User.create(email: 'test1@gmail.com', password: 'password', full_name: 'Test User 1')
user2 = User.create(email: 'test2@gmail.com', password: 'password', full_name: 'Test User 2', display_name: 'T2')
admin1 = User.create(email: 'admin@admin.ca', password: '123456', full_name: 'Admin Admin', display_name: 'Admin', admin:true)

Orders = Array.new(10)
Orders[0] = Order.create(user_id: user1.id, order_status: "placed", total_price: 12123)
item= OrderItem.create(order_id: Orders[0].id, product_id: Products[0].id, quantity: 2)

Orders[1] = Order.create(user_id: user1.id, order_status: "placed", total_price: 445)
OrderItem.create(order_id: Orders[1].id, product_id: Products[3].id, quantity: 1)


Orders[2] = Order.create(user_id: user2.id, order_status: "completed", total_price: 5456)
OrderItem.create(order_id: Orders[2].id, product_id: Products[5].id, quantity: 1)


Orders[3] = Order.create(user_id: user2.id, order_status: "completed", total_price: 445)
OrderItem.create(order_id: Orders[3].id, product_id: Products[1].id, quantity: 1)
