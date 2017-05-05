module Spree
  Order.class_eval do

    def create_subscriptions

      if !self.user
        self.user = Spree::User.find_by(:email => self.email)
      end

      line_items.each do |line_item|


        if line_item.variant.subscribable?


          #if there is an existing subscription (were doing a renewal of some sort)
          if line_item.renewing_subscription_id?

            subscription = Spree::AccountSubscription.find(line_item.renewing_subscription_id)


            enddate = subscription.end_datetime
            if enddate < DateTime.now
              enddate = DateTime.now
            end

            enddate += 365.days

            #this case is for renewing a single seat as spinoff, or renewing a subscription with less seats than it currently has
            if line_item.is_spinoff

              Spree::AccountSubscription.subscribe!(
                  email: self.email,
                  user: self.user,
                  product: line_item.variant.product,
                  start_datetime: subscription.start_datetime,
                  end_datetime: enddate,
                  order: self,
                  num_seats: line_item.quantity
              )

              #otherwise when renewing, we are updating the existing subscription object
            else
              subscription.order = self

              #if it is a renewal, extend the enddate
              if line_item.variant.renewal

                subscription.end_datetime = enddate

                #otherwise we are adding seats to this subscription
              else

                subscription.num_seats += line_item.quantity

              end

              subscription.save

            end

            #if no existing subscription. create a new one altogether!
          else

            end_datetime = DateTime.now + 365.days

            Spree::AccountSubscription.subscribe!(
                email: self.email,
                user: self.user,
                product: line_item.variant.product,
                start_datetime: DateTime.now,
                end_datetime: end_datetime,
                order: self,
                num_seats: line_item.quantity
            )
            line_item.quantity=1


          end
        end
      end
    end

  end
end
