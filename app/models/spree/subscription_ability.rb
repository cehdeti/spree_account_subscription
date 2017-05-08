module Spree
  class SubscriptionAbility
    include CanCan::Ability

    def initialize user
      # direct permissions
      puts("user: #{user}")
      if user.id
        can :view, Spree::AccountSubscription
        can :manage, Spree::AccountSubscription
        can :create, Spree::AccountSubscription

        can :view, Spree::SubscriptionSeat
        can :manage, Spree::SubscriptionSeat
        can :create, Spree::SubscriptionSeat
      end

    end
  end
end
