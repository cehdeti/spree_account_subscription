module Spree
  Product.class_eval do
    has_many :account_subscriptions, foreign_key: 'product_id'
    has_one :product, foreign_key: 'existing_subscription_id'

    scope :subscribable, -> { where(subscribable: true) }
    scope :unsubscribable, -> { where(subscribable: false) }

    def renewable?
      variants.for_subscription_renewal.exists?
    end
  end
end
