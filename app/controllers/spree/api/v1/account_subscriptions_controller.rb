module Spree
  module Api
    module V1
      class AccountSubscriptionsController < Spree::Api::BaseController

        require "time"
        before_action :find_account_subscription


        def show
          authorize! :show, @account_subcription

          #status in the case that subscription has lapsed
          status=211

          if !@account_subcription
            #no subscription, no content to send
            status=212

          else

            dif = @account_subcription.end_datetime - DateTime.now
            expires_in dif, :public => true

            response.headers["Expires"] = @account_subcription.end_datetime.httpdate

            if DateTime.now < @account_subcription.end_datetime

              #subscription is ok
              status=200

            end


          end


          render nothing: true, :status => status
        end


        private


          def find_account_subscription(lock = false)
            @account_subcription = Spree::AccountSubscription.
                order(:end_datetime).
                find_by(user_id: params[:user_id])

          end

      end
    end
  end
end
