class LineItemsController < ApplicationController

  def create
    chosen_product = Product.find(params[:product_id])
    if chosen_product.available
      current_cart = @current_cart
      if current_cart.products.include?(chosen_product)
        @line_item = current_cart.line_items.find_by(:product_id => chosen_product)
        @line_item.quantity += 1
      else
        @line_item = LineItem.new
        @line_item.cart = current_cart
        @line_item.product = chosen_product
        @line_item.quantity = 1
      end
      @line_item.save
      flash[:notice] = 'Product added in cart'
      redirect_to request.referer
    else
      flash[:notice] = 'Product is suspended for sale!!!'
      redirect_to products_path
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    redirect_to cart_path
  end

  def add_quantity
    @line_item = LineItem.find(params[:id])
    @line_item.quantity += 1
    @line_item.save
    redirect_to cart_path
  end

  def reduce_quantity
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity > 1
      @line_item.quantity -= 1
    end
    @line_item.save
    redirect_to cart_path
  end

  private
    def line_item_params
      params.require(:line_item).permit(:quantity,:product_id, :cart_id)
    end

end
