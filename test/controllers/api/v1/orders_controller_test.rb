require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test"should not allow orders if user not login"do
    get api_v1_orders_url, as: :json
    assert_response :unauthorized
  end

  test "should show all orders if user is logged in" do
    get api_v1_orders_url,
     headers:{
      Authorization: JsonWebToken.encode(user_id: @order.user_id)
    }, as: :json

    assert_response :success

    json_response= JSON.parse(response.body)
    assert_equal @order.user.orders.count, json_response['data'].count
  end

  test "should show a single order" do
    # api/v1/orders/:id
    get api_v1_order_url(@order),
    headers:{
      Authorization: JsonWebToken.encode(user_id: @order.user_id)
    }, as: :json

    assert_response :success

    json_response= JSON.parse(response.body)
    include_product_attr = json_response['included'][0]['attributes']

    assert_equal @order.products.first.title, include_product_attr['title']
  end


end
