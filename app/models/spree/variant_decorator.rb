module Spree
  Variant.class_eval do

    delegate :subscribable?, to: :product


    def renewal
      return self.is_renewal
    end

  end
end
