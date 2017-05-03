module Spree
  LineItem.class_eval do


    has_one :spree_account_subscription, foreign_key: 'renewing_subscription_id'

    has_one :spree_subscription_seat, foreign_key: 'renewing_seat_id'

    validate :renewal_check

    def subscribable_product?
      product.subscribable?
    end


    def renewal_check
      #check for single seat spinoff renewals
      if self.renewing_seat_id && self.is_spinoff
        if self.quantity > 1
          errors.add(:variant,'Single seat renewal is limited to a quantity of 1')
          self.quantity = 1
        end
      end

      #check for full subscription renewals, make sure renewal seats arent greater than num seats
      if self.renewing_subscription_id && !self.is_spinoff

        sub = Spree::AccountSubscription.find(self.renewing_subscription_id)
        if self.quantity > sub.num_seats
          errors.add(:variant, 'Cannot renew more seats than in original subscription')
          self.quantity = sub.num_seats
        end
      end
    end

  end
end
