Spree::Variant.class_eval do
  scope :for_new_subscription, -> { where(new_subscription_variant: true) }
  scope :for_subscription_renewal, -> { where(renewal_subscription_variant: true) }

  delegate :subscribable?, to: :product
end
