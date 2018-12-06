module Spree
  class SubscriptionAbility
    include CanCan::Ability

    def initialize(user)
      return unless user.id
      can :view, Spree::AccountSubscription
      can :manage, Spree::AccountSubscription
      can :create, Spree::AccountSubscription
    end

  end
end
