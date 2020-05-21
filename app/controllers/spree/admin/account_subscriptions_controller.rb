module Spree
  module Admin
    class AccountSubscriptionsController < ResourceController
      before_action :load_options, only: [:create, :update]

      def index
        params[:q] ||= {}
        @search = Spree::AccountSubscription.search(params[:q])
        @account_subscriptions = @search.result.page(params[:page]).per(15)
      end

      def show
        redirect_to(action: :edit)
      end

      def create
        create_or_update Spree.t("subscription_successfully_created")
      end

      def update
        create_or_update Spree.t("subscription_successfully_updated")
      end

      protected

      def load_options
        @products = Product.subscribable.all.pluck(:name, :id)
        @users = Spree::User.all.pluck(:email, :id)
      end

    private

      def create_or_update(flash_msg)
        if @account_subscription.update_attributes(subscription_params)
          user = Spree::User.find_by(id: subscription_params[:user_id])
          @account_subscription.user_id = user.id
          @account_subscription.email = user.email
          @account_subscription.save
          redirect_to edit_admin_account_subscription_path(@account_subscription)
          flash.notice = flash_msg
        else
          respond_with(@account_subscription)
        end
      end

      def subscription_params
        params.require(:account_subscription).permit(
          :email, :user_id,
          :product_id, :start_datetime, :is_renewal,
          :end_datetime, :order, :num_seats,
          :renewing_subscription_id
        )
      end
    end
  end
end
