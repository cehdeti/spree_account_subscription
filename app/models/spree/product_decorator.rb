module Spree
  Product.class_eval do

    has_many :account_subscriptions, foreign_key: "product_id"

    has_one :spree_product, foreign_key: 'existing_subscription_id'

    scope :subscribable, -> { where(subscribable: true) }
    scope :unsubscribable, -> { where(subscribable: false) }


  end
end
