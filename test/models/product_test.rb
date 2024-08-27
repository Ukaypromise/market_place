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

  test "search should return empty if title or price is not found" do
    search_query = {keyword: "table", min_price: 500}
    assert Product.search(search_query).empty?
  end

  test"search should find an item if present" do
    search_query = {keyword: "Samsung", min_price: 1400, max_price: 1600 }
    assert_equal [products(:three)], Product.search(search_query)
  end

  test "should return all products when no search query or parameters" do
    assert_equal Product.all.to_a, Product.search({})
  end

  test "search should return or filter products by id" do
    search_query = {product_ids: products(:one).id}
    assert_equal [products(:one)], Product.search(search_query)
  end

end
