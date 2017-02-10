class AbandonedCartService
  class << self
    def perform
      Spree::Order.abandon_not_notified.each do |order|
        next unless order.last_for_user?
        order.abandoned_cart_actions
      end
    end
  end
end
