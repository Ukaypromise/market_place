require "test_helper"

class UserTest < ActiveSupport::TestCase
  test " user with a valid email should be valid " do
    user = User.new(email: "test@gmail.com", password_digest:"123456")
    assert user.valid?

  end

  test " user with invalid email should invalid" do
    user = User.new(email: "test.com", password_digest:"123456")
    assert_not user.valid?
  end

  test "user with email already taken should be invalid" do
    other_user = users(:one)
    user = User.new(email: other_user.email, password_digest:"123456")

    assert_not user.valid?
  end

  test "user without password should be not be valid" do
    user = User.new(email: "test@gmail.com", password_digest:nil)
    assert_not user.valid?
  end

  test "destroy user should destroy linked products" do
    assert_difference('Product.count', -1) do
      users(:one).destroy
    end
  end
end
