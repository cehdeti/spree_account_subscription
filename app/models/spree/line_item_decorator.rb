module Spree
  LineItem.class_eval do

    has_one :account_subscription, foreign_key: 'renewing_subscription_id'

    validate :renewal_check

    delegate :subscribable?, to: :product

  private

    def renewal_check
      # check for single seat spinoff renewals
      if is_spinoff && quantity > 1
        errors.add(:variant, 'Single seat renewal is limited to a quantity of 1')
        self.quantity = 1
      end

      # check for full subscription renewals, make sure renewal seats arent
      # greater than num seats
      if renewing_subscription_id && !is_spinoff
        sub = Spree::AccountSubscription.find(renewing_subscription_id)
        if quantity > sub.num_seats
          errors.add(:variant, 'Cannot renew more seats than in original subscription')
          self.quantity = sub.num_seats
        end
      end
    end

  end
end