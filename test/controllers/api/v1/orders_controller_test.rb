require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @order_params = {
      order: { product_ids: [products(:one).id, products(:two).id],
                total: 4
    }
    }
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

  test "should not allow user to create an order if not logged in" do
    assert_no_difference('Order.count') do
      post api_v1_orders_url, params: @order_params, as: :json
    end
    assert_response :unauthorized
  end

  test "should create an order with two products" do
    assert_difference('Order.count', 1) do
      post api_v1_orders_url, params: @order_params,
      headers: {
        Authorization: JsonWebToken.encode(user_id: @order.user_id)
      }, as: :json
    end
    assert_response :created
  end

end
