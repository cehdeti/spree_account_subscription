module Spree
  class Promotion
    module Actions
      class ExtendSubscription < Spree::PromotionAction
        def perform(options = {})
          order = options[:order]
          order.toggle!(:should_extend_subscription) unless order.should_extend_subscription?
        end

        def revert(options = {})
          order = options[:order]
          order.toggle!(:should_extend_subscription) if order.should_extend_subscription?
        end
      end
    end
  end
end
