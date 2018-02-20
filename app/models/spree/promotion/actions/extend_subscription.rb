module Spree
  class Promotion
    module Actions
      class ExtendSubscription < Spree::PromotionAction
        def perform(options = {})
          order = options[:order]

          return false if order.should_extend_subscription? || order.line_items.none? do |line_item|
            promotion.line_item_actionable?(order, line_item)
          end

          order.toggle!(:should_extend_subscription)
        end

        def revert(options = {})
          order = options[:order]
          order.toggle!(:should_extend_subscription) if order.should_extend_subscription?
        end
      end
    end
  end
end
