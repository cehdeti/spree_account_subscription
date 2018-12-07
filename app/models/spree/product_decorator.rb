module Spree
  Product.class_eval do

    has_many :account_subscriptions, foreign_key: 'product_id'
    has_one :product, foreign_key: 'existing_subscription_id'

    scope :subscribable, -> { where(subscribable: true) }
    scope :unsubscribable, -> { where(subscribable: false) }

    def can_renew
      !renewal_variant.nil?
    end

    def renewal_variant
      variants.find(&:renewal)
    end

    def new_variant
      variants.find{|variant| !variant.renewal }
    end

  end
end