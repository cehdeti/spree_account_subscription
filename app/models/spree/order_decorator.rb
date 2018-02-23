module Spree
  Order.class_eval do

    has_many :account_subscriptions, class_name: 'Spree::AccountSubscription', inverse_of: :order

    def create_subscriptions

      self.user = Spree::User.find_by(email: email) unless user

      line_items.select { |i| i.variant.subscribable? }.each do |line_item|
        # If there is an existing subscription (were doing a renewal of some
        # sort)
        if line_item.renewing_subscription_id?
          subscription = Spree::AccountSubscription.find(line_item.renewing_subscription_id)

          enddate = if subscription.end_date < DateTime.now
                      DateTime.now
                    else
                      subscription.end_datetime
                    end + 365.days

          # This case is for renewing a single seat as spinoff, or renewing a
          # subscription with less seats than it currently has.
          if line_item.is_spinoff
            Spree::AccountSubscription.subscribe!(
              email: email,
              user: user,
              product: line_item.variant.product,
              start_datetime: subscription.start_datetime,
              end_datetime: enddate,
              order: self,
              num_seats: line_item.quantity,
              is_renewal: true,
              renewal_date: Date.today
            )

          # Otherwise when renewing, we are updating the existing subscription
          # object
          else
            subscription.order = self

            # If it is a renewal, extend the enddate
            if line_item.variant.renewal

              subscription.end_datetime = enddate

            # Otherwise we are adding seats to this subscription
            else

              subscription.num_seats += line_item.quantity

            end
            subscription.is_renewal = true
            subscription.renewal_date = Date.today
            subscription.save

          end

        # If no existing subscription. create a new one altogether!
        else
          Spree::AccountSubscription.subscribe!(
            email: email,
            user: user,
            product: line_item.variant.product,
            start_datetime: DateTime.now,
            end_datetime: get_adjusted_subscription_end_datetime(line_item),
            order: self,
            num_seats: line_item.quantity,
            is_renewal: false,
            renewal_date: nil
          )
          line_item.quantity = 1
        end
      end

      toggle!(:should_extend_subscription) if should_extend_subscription?
    end

    private

    # Given a line item, calculate a new subscription end date, taking into
    # account any coupon codes that are applied to the order that may extend
    # the subscription length. Returns the new subscription end date.
    def get_adjusted_subscription_end_datetime(line_item)
      end_datetime = DateTime.now + 365.days

      return end_datetime unless should_extend_subscription?

      extending_promo = promotions.find do |promo|
        promo.actions.any? { |action| action.is_a?(Spree::Promotion::Actions::ExtendSubscription) } &&
          promo.line_item_actionable?(self, line_item)
      end

      return end_datetime unless extending_promo

      # Pick the extension that results in the greatest subscription length so
      # that the user gets the best deal.
      possible_enddates = extending_promo.actions
        .select { |a| a.is_a?(Spree::Promotion::Actions::ExtendSubscription) }
        .map do |action|
          case action.preferred_extension_policy
          when Spree::Promotion::Actions::ExtendSubscription::EXTENSION_POLICY_PERIOD
            end_datetime + action.preferred_period_quantity.to_i.send(action.preferred_period_unit)
          when Spree::Promotion::Actions::ExtendSubscription::EXTENSION_POLICY_DATE
            DateTime.parse(action.preferred_end_date)
          end
        end
      possible_enddates << end_datetime

      possible_enddates.max
    end
  end
end
