class Api::ProductsController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :set_product, only: %i[show update destroy]
  before_action :authenticate_user!
  
  def index
    @products = if params[:page].present?
      Product.page(params[:page])
    elsif params[:category_id].present?
      Product.joins(:categories).where(categories: { id: params[:category_id]}).page(0)
    else
      Product.all.page(0)
    end
    render json: { message: "List of products", status: 200, body: @products }, status: 200
  end

  def show
    render json: { message: "Product Found!", status: 200, body: @product }, status: 200
  end

  def update
    if @product.update(product_params)
      render json: { message: "Product updated successfully!", status: 200, body: @product }, status: 200
    else
      render json: { message: @product.errors.full_messages.join(', '), status: 409 }, status: 409
    end
  end

  def destroy
    @product.destroy
    render json: { message: "Product deleted successfully!", status: 200 }, status: 200
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :description, :price, :image, category_ids: [])
  end

  def record_not_found
    render json: { message: "Product not found!", status: 404 }, status: 404
  end
end
