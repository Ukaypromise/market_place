require "test_helper"

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @product= products(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
  end

  test "should show product list " do
    get api_v1_products_url(), as: :json
    assert_response :success

    json_response = JSON.parse(response.body, symbolize_names: true)

    assert_not_nil json_response.dig(:links, :first)
    assert_not_nil json_response.dig(:links, :last)
    assert_not_nil json_response.dig(:links, :prev)
    assert_not_nil json_response.dig(:links, :next)
  end

  test "should show product" do
    get api_v1_product_url(@product), as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal @product.title, json_response.dig(:data, :attributes, :title)
    assert_equal @product.user.id.to_s, json_response.dig(:data, :relationships, :user, :data, :id)
    assert_equal @product.user.email, json_response.dig(:included, 0, :attributes, :email)
  end

  test " should create a product " do
    assert_difference('Product.count') do
      post api_v1_products_url, params: {
        product:{
          title: @product.title,
          price: @product.price,
          availability: @product.availability
        }
      },
      headers: { 'Authorization': "Bearer #{@token}" }, as: :json
    end
    assert_response :created
  end

  test " should forbide creating a product " do
    assert_no_difference('Product.count') do
      post api_v1_products_url, params: {
        product:{
          title: @product.title,
          price: @product.price,
          availability: @product.availability
        }
      }
    end
    assert_response :unauthorized
  end

  test "should update a product" do
    patch api_v1_product_url(@product), params: {
        product:{
          title: @product.title,
          price: @product.price,
          availability: @product.availability
        }
      },
      headers: { 'Authorization': "Bearer #{@token}" }, as: :json
      assert_response :success
  end

  test "should not update a product if unauthorized" do
    patch api_v1_product_url(@product), params: {
        product:{
          title: @product.title,
          price: @product.price,
          availability: @product.availability
        }
      },
      headers: { Authorization: JsonWebToken.encode(user_id: users(:two).id) }, as: :json
      assert_response :forbidden
  end

  test "should delete product" do
    assert_difference('Product.count', -1) do
      delete api_v1_product_url(@product),
        headers: { 'Authorization': "Bearer #{@token}" }, as: :json
    end
    assert_response :success
  end

  test "should not delete if user is not authorized" do
    assert_no_difference('Product.count') do
      delete api_v1_product_url(@product),
      headers: { Authorization: JsonWebToken.encode(user_id: users(:two).id) }, as: :json
    end
    assert_response :forbidden
  end



end
