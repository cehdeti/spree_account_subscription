require 'time'

module Spree
  module Api
    module V1
      class AccountSubscriptionsController < Spree::Api::BaseController
        SUBSCRIPTION_OK_STATUS_CODE = 200
        LAPSED_SUBSCRIPTION_STATUS_CODE = 211
        NO_SUBSCRIPTION_STATUS_CODE = 212

        before_action :find_account_subscription

        def show
          authorize! :show, @account_subscription

          unless @account_subscription
            head NO_SUBSCRIPTION_STATUS_CODE
            return
          end

          dif = @account_subscription.end_datetime - DateTime.now
          expires_in dif, public: true
          response.headers['Expires'] = @account_subscription.end_datetime.httpdate
          status = if DateTime.now < @account_subscription.end_datetime
                     SUBSCRIPTION_OK_STATUS_CODE
                   else
                     LAPSED_SUBSCRIPTION_STATUS_CODE
                   end
          render 'show', status: status
        end

        private

        def find_account_subscription
          @all_subs = []

          get_by_user_id # Check if user is subscription owner
          get_by_token

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
          return unless params[:registration_code]
          subscription = scoped_subscriptions.find_by(token: params[:registration_code])
          return unless subscription
          @all_subs.append(subscription)
        end

        def scoped_subscriptions
          Spree::AccountSubscription.all
        end
      end
    end
  end
end
