require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "should have a positive price value" do
    product = products(:one)
    product.price = -1
    assert_not product.valid?
  end
end
