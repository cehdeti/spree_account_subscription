require 'time'

module Spree
  class SeatsController < Spree::BaseController

    before_action :check_authorization
    before_action :find_seat

    helper 'spree/products'
    include Spree::Core::ControllerHelpers::Order

    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    def show
      @product = @seat.account_subscription.product
      if @seat.user != spree_current_user
        @message = 'You do not have permissions to view this item'
        render 'spree/shared/forbidden', layout: Spree::Config[:layout], status: 403
      end
    end

    def edit
    end

    def create
      update
    end

    def update
      redirect = params[:seat][:redirect]
      revoke = params[:seat][:revoke].to_i
      email = params[:seat][:email]
      user = Spree::User.find_by(email: email)

      if revoke > 0
        seat = Spree::SubscriptionSeat.find_by(account_subscription: @subscription, user: user)
        if seat
          seat.destroy
          flash[:notice] = 'Seat has been cleared. You may now assign it to someone else'
        else
          flash[:notice] = "Seat with owner #{email} not found"
        end
      elsif user
        seat = Spree::SubscriptionSeat.find_by(account_subscription: @subscription, user: user)
        if seat
          flash[:notice] = "Seat with email #{email} has been confirmed"
        else
          seat = Spree::SubscriptionSeat.new
          seat.account_subscription = @subscription
          seat.user = user
          seat.save
          flash[:notice] = "Seat with email #{email} has been assigned!"
        end
      else
        flash[:error] = "user with email `#{email}` not found"
      end

      redirect_to(redirect)
    end

    private

    def check_authorization
      authorize!(:show, nil, message: 'please login') unless spree_current_user
    end

    def find_seat
      @seat = Spree::SubscriptionSeat.find(params[:id]) if params[:id].present?
      @subscription = Spree::AccountSubscription.find(params[:subscription_id]) if params[:subscription_id].present?
    end
  end
end
