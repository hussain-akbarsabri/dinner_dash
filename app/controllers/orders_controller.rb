class OrdersController < ApplicationController
  before_action :authenticate_user!
  def index
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
    @order_items = @order.order_items
  end

  def edit; end

  def create
    if @current_cart.line_items.size == 0
      flash[:notice] = 'No Item in the cart'
      redirect_to cart_path
    elsif current_user.admin?
      flash[:notice] << 'Admin cannot place an order'
      redirect_to root_path
    else
      @order = Order.create(user: current_user, order_status: "placed")
      create_order_items()

      if @order.save
        delete_cart()
        calculate_total_price()
        flash[:notice] = 'Order placed Successfully'
      else
        flash[:notice] = 'Order placement failed'
      end
      redirect_to root_path
    end
  end

  def destroy; end

  def orders_dashboard
    @orders = Order.all
  end

  private

  def create_order_items
      @current_cart.line_items.includes(:product).each do |line_item|
      order_item = OrderItem.new
      order_item.order_id = @order.id
      order_item.product = line_item.product
      order_item.quantity = line_item.quantity
      order_item.save
    end
  end

  def delete_cart
    @current_cart.destroy
    session[:cart_id] = nil
  end

  def calculate_total_price
    @order.total_price=0
    @order.order_items.each do |order_item|
      @order.total_price+=order_item.quantity * order_item.product.price
    end
    @order.save
  end
end
