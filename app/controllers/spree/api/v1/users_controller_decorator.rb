Spree::Api::V1::UsersController.class_eval do

  before_action :include_user_subscriptions, only: [:show, :account_subscriptions]

  def account_subscriptions
    respond_with(@account_subscriptions)
  end

private

  def include_user_subscriptions
    @account_subscriptions = Spree::AccountSubscription.order(:end_datetime).where(user_id: user.id)
  end

end
