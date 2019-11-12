Spree::Admin::UsersController.class_eval do
  def account_subscriptions
    params[:q] ||= {}
    @search = Spree::AccountSubscription.ransack(params[:q].merge(user_id_eq: @user.id))
    @account_subscriptions = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page])
  end
end
