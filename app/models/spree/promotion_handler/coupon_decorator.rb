module Spree
  module PromotionHandler
    Coupon.class_eval do

      # We need to override this from spree core to tell spree that coupons
      # that extend the subscription length are a good deal. Otherwise, it will
      # say that a better deal exists.
      def determine_promotion_application_result
        # Check for applied adjustments.
        discount = order.all_adjustments.promotion.eligible.detect do |p|
          p.source.promotion.code.try(:downcase) == order.coupon_code.downcase
        end

        # Check for applied line items.
        created_line_items = promotion.actions.detect do |a|
          Object.const_get(a.type).ancestors.include?(
            Spree::Promotion::Actions::CreateLineItems
          )
        end

        extended_subscription = promotion.actions.detect do |a|
          Object.const_get(a.type).ancestors.include?(
            Spree::Promotion::Actions::ExtendSubscription
          )
        end

        if discount || created_line_items || extended_subscription
          order.update_totals
          order.persist_totals
          set_success_code :coupon_code_applied
        elsif order.promotions.with_coupon_code(order.coupon_code)
          # if the promotion exists on an order, but wasn't found above,
          # we've already selected a better promotion
          set_error_code :coupon_code_better_exists
        else
          # if the promotion was created after the order
          set_error_code :coupon_code_not_found
        end
      end
    end
  end
end
