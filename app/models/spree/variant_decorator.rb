module Spree
  Variant.class_eval do

    delegate :subscribable?, to: :product

    def renewal
      is_renewal
    end

  end
end
