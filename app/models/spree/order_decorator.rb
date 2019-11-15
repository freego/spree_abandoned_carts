module Spree
  module OrderDecorator
    def self.prepended(base)
      base.scope :abandoned,
        -> { limit_time = Time.current - SpreeAbandonedCarts::Config.abandoned_after_minutes.minutes

             incomplete.
             where('email IS NOT NULL').
             where("#{quoted_table_name}.item_total > 0").
             where("#{quoted_table_name}.updated_at < ?", limit_time) }

      base.scope :abandon_not_notified,
        -> { abandoned.where(abandoned_cart_email_sent_at: nil) }
    end

    def abandoned_cart_actions
      AbandonedCartMailer.abandoned_cart_email(self).deliver_now
      touch(:abandoned_cart_email_sent_at)
    end

    def last_for_user?
      Order.where(email: email).where('id > ?', id).none?
    end
  end
end

::Spree::Order.prepend(Spree::OrderDecorator)
