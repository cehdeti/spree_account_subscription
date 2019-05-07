require 'time'

module Spree
  class SubscriptionsController < Spree::StoreController
    before_action :find_account_subscriptions, :find_subscription_seats
    before_action :check_authorization

    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    helper 'spree/products'
    include Spree::Core::ControllerHelpers::Order

    def index; end

    def show
      @subscription = Spree::AccountSubscription.includes(:subscription_seats).find(params[:id])
      @product = @subscription.product

      return if @subscription.user == spree_current_user || spree_current_user.admin?

      @message = 'You do not have permissions to view this item'
      render 'spree/shared/forbidden', layout: Spree::Config[:layout], status: 403
    end

    # Adds a new item to the order (creating a new order if none already exists)
    def renew
      subscription = @subscriptions.find(params[:id])
      order = current_order(create_order_if_necessary: true)
      renewal_variant = subscription.product.variants.for_subscription_renewal.find(params[:variant_id])
      quantity = params[:quantity].to_i
      options  = { renewing_subscription_id: subscription.id }
      errors = []

      # If its less or equal than the current number of seats, we use renewal
      # variant for all of them.
      if quantity <= subscription.num_seats
        # If it less that current number of seats, create a new subscription as
        # spinoff.
        options[:is_spinoff] = quantity < subscription.num_seats
        errors = populate_order(order, renewal_variant, quantity, options, errors)

      # Otherwise, we use some of the renewal variant, and some of the new
      # variant.
      else
        new_variant = case
                      when renewal_variant.new_subscription_variant? then renewal_variant
                      when subscription.product.variants.active.for_new_subscription.count == 1
                        subscription.product.variants.active.for_new_subscription.first
                      else raise 'Cannot find new variant for subscription'
                      end
        errors = populate_order(order, renewal_variant, subscription.num_seats, options, errors)
        difference = quantity - subscription.num_seats
        errors = populate_order(order, new_variant, difference, options, errors)
      end

      if errors.empty?
        respond_with(order) do |format|
          format.html { redirect_to cart_path }
        end
      else
        flash[:error] = errors.join(', ')
        redirect_back_or_default(spree.root_path)
      end
    end

    private

    def find_account_subscriptions
      @subscriptions = Spree::AccountSubscription.where(user: spree_current_user)
    end

    def find_subscription_seats
      puts("spree current user: #{spree_current_user}")

      @seats = Spree::SubscriptionSeat.where(user: spree_current_user)
    end

    def check_authorization
      authorize!(:index, nil, message: 'please log in') unless spree_current_user
    end

    def populate_order(order, variant, quantity, options, errors)
      begin
        order.contents.add(variant, quantity, options)
        order.update_line_item_prices!
        order.create_tax_charge!
        order.update_with_updater!
      rescue ActiveRecord::RecordInvalid => e
        errors.push(e.record.errors.full_messages.join(", "))
      end

      errors
    end
  end
end
