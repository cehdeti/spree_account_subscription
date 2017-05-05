module Spree
  Product.class_eval do

    has_many :account_subscriptions, foreign_key: "product_id"

    has_one :spree_product, foreign_key: 'existing_subscription_id'

    scope :subscribable, -> { where(subscribable: true) }
    scope :unsubscribable, -> { where(subscribable: false) }


    def renewal_variant
      renewal=nil
      self.variants.each do |variant |
        if variant.renewal
          renewal = variant
        end
      end
      renewal
    end

    def new_variant
      newv=nil
      self.variants.each do |variant |
        if !variant.renewal
          newv = variant
        end
      end
      newv
    end
  end
end
