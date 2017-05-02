module Spree
  class SubscriptionsController < Spree::BaseController

    require "time"
    before_filter :check_auth, :find_account_subscriptions, :find_subscription_seats

    rescue_from ActiveRecord::RecordNotFound, :with => :render_404


    def index
      puts("ALL SUBSCRIPTION: #{@all_subscriptions}")
    end

    def show
      @subscription = Spree::AccountSubscription.includes(:subscription_seats).find(params[:id])

      if @subscription.user != spree_current_user
        @message = 'You do not have permissions to view this item'
        render 'spree/shared/forbidden', layout: Spree::Config[:layout], status: 403
      end

    end


    private

    def find_account_subscriptions
      @all_subscriptions = Spree::AccountSubscription.where(:user => spree_current_user)
    end

    def find_subscription_seats
      @seats = Spree::SubscriptionSeat.where(:user => spree_current_user)
    end

    def check_auth

      redirect_to '/', notice: 'Login Required' unless spree_current_user
#      sub = nil
#      if params[:id].present?
#        sub = Spree::AccountSubscription.find(params[:id])
#      end

#      if sub
#        authorize! :show,:edit, sub
#      else
#        authorize! :index
#      end

    end
  end
end