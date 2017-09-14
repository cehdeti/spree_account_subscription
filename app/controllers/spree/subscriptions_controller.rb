module Spree
  class SubscriptionsController < Spree::StoreController

    require "time"
    before_filter :find_account_subscriptions, :find_subscription_seats
    before_action :check_authorization

    rescue_from ActiveRecord::RecordNotFound, :with => :render_404

    helper 'spree/products'
    include Spree::Core::ControllerHelpers::Order

    helper_method :renewal_price

    def index
      puts("ALL SUBSCRIPTION: #{@all_subscriptions}")
    end

    def show
      @subscription = Spree::AccountSubscription.includes(:subscription_seats).find(params[:id])
      @product = @subscription.product

      if @subscription.user != spree_current_user and not spree_current_user.admin?
        @message = 'You do not have permissions to view this item'
        render 'spree/shared/forbidden', layout: Spree::Config[:layout], status: 403
      end

    end


    # Adds a new item to the order (creating a new order if none already exists)
    def processrenewal
      order    = current_order(create_order_if_necessary: true)
      new_variant  = Spree::Variant.find(params[:new_id])
      renewal_variant = Spree::Variant.find(params[:renewal_id])
      subscription = Spree::AccountSubscription.find(params[:subscription_id])
      quantity = params[:quantity].to_i
      options  = params[:options] || {}
      errors = []

      #if its less or equal than the current number of seats, we use renewal variant for all of them
      if quantity <= subscription.num_seats

        #if it less that current number of seats, create a new subscription as spinoff
        if quantity < subscription.num_seats
          options[:is_spinoff] = true
        end

        errors = populate_order(order, renewal_variant, quantity, options, errors)

      #otherwise, we use some of the renewal variant, and some of the new variant
      else

        errors = populate_order(order, renewal_variant, subscription.num_seats, options, errors)

        difference = quantity - subscription.num_seats

        errors = populate_order(order, new_variant, difference, options, errors)

      end

      if errors.length > 0
        flash[:error] = errors.join(', ')
        redirect_back_or_default(spree.root_path)
      else
        respond_with(order) do |format|
          format.html { redirect_to cart_path }
        end
      end


    end

    private

    def find_account_subscriptions
      @all_subscriptions = Spree::AccountSubscription.where(:user => spree_current_user)
    end

    def find_subscription_seats
      puts("spree current user: #{spree_current_user}")

      @seats = Spree::SubscriptionSeat.where(:user => spree_current_user)
    end

    def check_authorization
      unless spree_current_user
        authorize!(:index, nil, {:message=>'please login'})
      end
    end


    def renewal_price( variant , seats)
      Spree::Money.new(variant.price_in(current_currency).amount * seats).to_html
    end


    def populate_order( order, variant, quantity, options, errors )

      begin
        order.contents.add(variant, quantity, options)
      rescue ActiveRecord::RecordInvalid => e
        errors.push(  e.record.errors.full_messages.join(", "))
      end

      errors
    end

  end
end