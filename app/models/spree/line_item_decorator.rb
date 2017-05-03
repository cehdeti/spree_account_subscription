module Spree
  LineItem.class_eval do


    has_one :spree_account_subscription, foreign_key: 'renewing_subscription_id'

    has_one :spree_subscription_seat, foreign_key: 'renewing_seat_id'

    validate :renewal_check

    def subscribable_product?
      product.subscribable?
    end


    def renewal_check
      puts("RENEWAL CHECK: #{self.to_yaml}")



      if self.renewing_seat_id && self.is_spinoff
        if self.quantity > 1
          errors.add(:variant,'Single seat renewal is limited to a quantity of 1')
          self.quantity = 1
        end
      end

      true
    end

  end
end
