module Spree


  class SeatsController < Spree::BaseController

    require "time"
    before_filter :get_seat, :check_auth

    helper 'spree/products'
    include Spree::Core::ControllerHelpers::Order

    rescue_from ActiveRecord::RecordNotFound, :with => :render_404


    def show

      @product = @seat.account_subscription.product
      if @seat.user != spree_current_user
        @message = 'You do not have permissions to view this item'
        render 'spree/shared/forbidden', layout: Spree::Config[:layout], status: 403
      end

    end


    def renew

    end



    private

    def check_auth
      authorize! :show,:edit, Spree::SubscriptionSeat
    end


    def get_seat
      @seat = nil
      if params[:id].present?
        @seat = Spree::SubscriptionSeat.find(params[:id])
      end
    end
  end
end