class Spree::SubscriptionSeat < ActiveRecord::Base
  belongs_to :account_subscription, class_name: 'Spree::AccountSubscription'
  belongs_to :user, class_name: Spree.user_class

  validates :user, uniqueness: { scope: :account_subscription,
                                 message: 'only one redemption per user and subscription' }
end
