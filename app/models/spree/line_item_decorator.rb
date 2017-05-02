module Spree
  LineItem.class_eval do


    has_one :spree_account_subscription, foreign_key: 'renewing_subscription_id'

    has_one :spree_subscription_seat, foreign_key: 'renewing_seat_id'

    validate :renewal_check

    def subscribable_product?
      product.subscribable?
    end


    def renewal_check
      puts("RENEWAL CHECK: #{self.variant}")

      if self.renewing_seat_id

        puts("validate renewing seat id!!!!! #{self.renewing_seat_id}")

      end

      true
    end

  end
end
