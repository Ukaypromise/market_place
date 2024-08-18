class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate_user, only: [:show, :index]
  before_action :check_login, only: [:create]
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:update, :destroy]

  def index
    @products = Product.all
    render json: ProductSerializer.new(@products).serializable_hash
  end

  def show
    options = {include: [:user]}
    render json: ProductSerializer.new(@product, options ).serializable_hash
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      render json: ProductSerializer.new(@product).serializable_hash, status: :created
    else
      render json: {
        errors: @product.errors
      }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: ProductSerializer.new(@product).serializable_hash
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      render json: {message: "Delete was successful"}, status: :ok
    else
      render json: {message: "Delete was not successful"}, status: :unprocessable_entity
    end
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :price, :availability)
  end

  def check_owner
    head :forbidden unless @product.user_id == current_user&.id
  end

end
