module Spree
  class SubscriptionAbility
    include CanCan::Ability

    def initialize(user)
      return unless user.id

      can :view, Spree::AccountSubscription
      can :manage, Spree::AccountSubscription
      can :create, Spree::AccountSubscription

      can :view, Spree::SubscriptionSeat
      can :manage, Spree::SubscriptionSeat
      can :create, Spree::SubscriptionSeat
    end
  end
end
