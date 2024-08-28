require "test_helper"

class OrderMailerTest < ActionMailer::TestCase

  setup do
    @order = orders(:one)
  end

  test "should send confirmation to the user for the order placed" do
    mail = OrderMailer.send_confirmation(@order)
    assert_equal "Order confirmation", mail.subject
    assert_equal [@order.user.email], mail.to
    assert_equal ["e-commerce@market.com"], mail.from
    assert_match "You have ordered #{@order.products.count} items", mail.body.encoded
  end

end
