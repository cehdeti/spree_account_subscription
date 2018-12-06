module Spree
  module ControllerHelpers
    module AccountSubscription
      extend ActiveSupport::Concern

      included do
        helper_method :subscription_for_order
        helper_attr :subscription
        attr_accessor :subscription
      end

      def subscription_for_order(order)
        @subscription = Spree::AccountSubscription.find_by(order_id: order.id)
      end

    end
  end
end
