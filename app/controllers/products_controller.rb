class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :authorize_user
  # GET /products or /products.json

  def index
    @products = if params[:page].present?
      Product.page(params[:page])
    elsif params[:category_id].present?
      Product.joins(:categories).where(categories: { id: params[:category_id]}).page(0)
    else
      Product.all.page(0)
    end
  end

  def retire_product
    @product = Product.find(params[:id])
    @product.available=false
    if @product.save
      flash[:notice]="Product retired successfully..."
    else
      flash[:notice]="Failed to retire product..."
    end
    redirect_to products_path
  end

  def resume_product
    @product = Product.find(params[:id])
    @product.available=true
    if @product.save
      flash[:notice]="Product resumed successfully..."
    else
      flash[:notice]="Failed to resume product..."
    end
    redirect_to products_path
  end

  # GET /products/1 or /products/1.json
  def show; end

  # GET /products/new
  def new

    @product = Product.new
  end

  # GET /products/1/edit
  def edit; end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        attach_placeholder_image unless @product.image.attached?
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def category_products
    @products = Product.joins(:categories).where(categories: { id: params[:category_id]}).uniq
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:title, :description, :price, :image, category_ids: [])
  end

  def attach_placeholder_image
    file = URI.open("https://res.cloudinary.com/dijou1ibj/products/placeholder_image.jpg")
    @product.image.attach(io: file, filename: 'placeholder_image')
  end

  def authorize_user
    authorize Product
  end
end
