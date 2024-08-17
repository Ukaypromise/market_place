class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate_user, only: [:show, :index]
  before_action :check_login, only: [:create]
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :check_owner, only: [:update, :destroy]

  def index
    @products = Product.all
    render json: @products
  end

  def show
    render json: @product
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: {
        errors: @product.errors
      }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head 204
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
