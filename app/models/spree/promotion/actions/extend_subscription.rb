module Spree
  class Promotion
    module Actions
      class ExtendSubscription < Spree::PromotionAction

        EXTENSION_POLICY_PERIOD = 'period'.freeze
        EXTENSION_POLICY_DATE = 'date'.freeze
        EXTENSION_POLICIES = [
          EXTENSION_POLICY_PERIOD,
          EXTENSION_POLICY_DATE,
        ].freeze

        PERIOD_UNITS = %w(years months days).freeze

        preference :extension_policy, :string, default: EXTENSION_POLICIES.first
        preference :period_quantity, :integer
        preference :period_unit, :string
        preference :end_date, :string

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
