module Spree
  LineItem.class_eval do

    validate :renewal_check

    def subscribable_product?
      product.subscribable?
    end


    def renewal_check
      true
    end

  end
end
