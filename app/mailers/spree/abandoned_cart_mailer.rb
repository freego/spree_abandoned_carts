module Spree
  class AbandonedCartMailer < BaseMailer
    def abandoned_cart_email(order)
      @order = order
      subject = "#{Spree::Store.current.name} #{Spree.t(:abandoned_cart_subject)}"
      mail(to: order.email, from: from_address, subject: subject)
    end
  end
end
