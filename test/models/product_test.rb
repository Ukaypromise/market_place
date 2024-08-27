require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "should have a positive price value" do
    product = products(:one)
    product.price = -1
    assert_not product.valid?
  end

  test"should filter products by name" do
    assert_equal 2, Product.filter_by_title('MacBook').count
  end
  test" should filter products by name and sort the products" do
    assert_equal [products(:four), products(:two)], Product.filter_by_title('MacBook').sort
  end

  test "should filter products by the price and sort them" do
    assert_equal [products(:four), products(:two)], Product.above_or_equal_to_price(2000).sort
  end

  test "should filter products lower and sort them" do
    assert_equal [products(:three), products(:one)], Product.below_or_equal_to_price(2000).sort
  end

  test "should sort product by the most recent" do
    products(:two).touch
    assert_equal [products(:one),products(:three), products(:four), products(:two)], Product.recent.to_a
  end

end
