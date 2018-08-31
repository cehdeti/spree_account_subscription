require 'time'

module Spree
  module Api
    module V1
      class AccountSubscriptionsController < Spree::Api::BaseController
        LAPSED_SUBSCRIPTION_STATUS_CODE = 211
        NO_SUBSCRIPTION_STATUS_CODE = 212
        SUBSCRIPTION_OK_STATUS_CODE = 200

        before_action :find_account_subscription

        def show
          authorize! :show, @account_subscription

          if !@account_subscription
            status = NO_SUBSCRIPTION_STATUS_CODE
          else
            dif = @account_subscription.end_datetime - DateTime.now
            expires_in dif, public: true
            response.headers['Expires'] = @account_subscription.end_datetime.httpdate
            status = if DateTime.now < @account_subscription.end_datetime
                       SUBSCRIPTION_OK_STATUS_CODE
                     else
                       LAPSED_SUBSCRIPTION_STATUS_CODE
                     end
          end

          if @account_subscription && params[:show_details] && params[:show_details].to_i > 0
            render 'show_details'
          else
            render nothing: true, status: status
          end
        end

        private

        def find_account_subscription
          @all_subs = []

          get_by_user_id # Check if user is subscription owner
          get_by_token # also look for a subscription seat

          if @all_subs.length == 1
            @account_subscription = @all_subs.first
          elsif @all_subs.present?
            sub = @all_subs.first

            @all_subs.each do |check_sub|
              sub = check_sub if check_sub.end_datetime > sub.end_datetime
            end

            @account_subscription = sub
          end
        end

        def get_by_user_id
          return unless params[:user_id]

          sub = scoped_subscriptions
                .order(:end_datetime)
                .where(user_id: params[:user_id])
                .where('end_datetime > ?', DateTime.now)
                .first

          @all_subs.append(sub) unless sub.nil?
        end

        def get_by_token
          subscription = scoped_subscriptions.find_by(token: params[:registration_code])
          return unless subscription

          get_subscription_seat(subscription) || return if params[:user_id]

          @all_subs.append(subscription)
        end

        def get_subscription_seat(subscription)
          user_id = params[:user_id]
          seat = subscription.get_seat(user_id)
          seat = subscription.take_seat(user_id) unless seat
          seat
        end

        def scoped_subscriptions
          Spree::AccountSubscription.all
        end
      end
    end
  end
end
