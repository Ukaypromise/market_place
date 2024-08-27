require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test"should have total to be positive "do
    order = orders(:one)
    order.total = -1
    assert_not order.valid?
  end
end
