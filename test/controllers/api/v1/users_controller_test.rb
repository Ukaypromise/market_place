require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
  end
  test "should show user" do
    get api_v1_user_url(@user), headers: { 'Authorization': "Bearer #{@token}" }, as: :json
    assert_response :success

    json_response = JSON.parse(self.response.body)
    assert_equal @user.email, json_response['data']['attributes']['email']
  end

  test "should create a new user" do
    assert_difference('User.count') do
      post api_v1_users_url, params: {
        user: {
          email: "test@test.com",
          password: "password"
        }
      }, as: :json
    end
    assert_response :created
  end

  test "should not create a new user if email is taken" do
    assert_no_difference('User.count') do
      post api_v1_users_url, params: {
        user: {
          email: @user.email,
          password: "password"
        }
      }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test "should be able to update user" do
    patch api_v1_user_url(@user), params: {
      user: {
        email: @user.email,
        password: "password"
      }
    },
    headers: { Authorization: JsonWebToken.encode(user_id: @user.id)},
     as: :json

    assert_response :success
  end

  test "should forbid updating user" do
    patch api_v1_user_url(@user), params: {
      user: {
        email: "wrong_email",
        password: "password"
      }
    }, headers: { 'Authorization': "Bearer #{@token}" }, as: :json

    assert_response :unprocessable_entity
  end

  test "should not update user when invalid params are present" do
    patch api_v1_user_url(@user), params: {
      user: {
        email: "wrong_email",
        password: "password"
      }
    },
    headers: { Authorization: JsonWebToken.encode(user_id: @user.id)},
     as: :json

    assert_response :unprocessable_entity
  end

  test " should delete/destroy a user" do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user),
      headers: { 'Authorization': "Bearer #{@token}" },
       as: :json
    end
    assert_response :no_content
  end

  test " should forbid delete/destroy a user if not authorised" do
    assert_no_difference('User.count') do
      delete api_v1_user_url(@user), as: :json
    end
    assert_response :unauthorized
  end

end
