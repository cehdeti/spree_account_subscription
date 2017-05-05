module Spree
  Order.class_eval do

    def create_subscriptions

      if !self.user
        self.user = Spree::User.find_by(:email => self.email)
      end


      puts("CCCCCCCCCCCCC")
      line_items.each do |line_item|
        puts("Checking line item: #{line_item}")
        if line_item.variant.subscribable?


          #if there is an existing subscription
          if line_item.spree_account_subscription

            subscription = AccountSubscription.find(line_item.renewing_subscription_id)

            puts("Editing current subscription: #{subscription}")
            #if it is a renewal of seats
            if line_item.variant.renewal

              puts("extending subscription")
              subscription.end_datetime = subscription.end_datetime + 365.days
              subscription.save
              puts("extended subscription: #{subscription.to_yaml}")

              #otherwise we are adding seats to this subscription
            else

              puts("adding seats to subscription")
              subscription.num_seats += line_item.quantity
              subscription.save
              puts("edited subscpription: #{subscription.to_yaml}")
            end

            line_item.quantity=1

          else
            puts("creating new subscription")

            AccountSubscription.subscribe!(
                email: self.email,
                user: self.user,
                product: line_item.variant.product,
                start_datetime: DateTime.now,
                end_datetime: DateTime.now + 365.days,
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
