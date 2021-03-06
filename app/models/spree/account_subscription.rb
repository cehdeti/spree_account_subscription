module Spree
  class AccountSubscription < ActiveRecord::Base

    has_secure_token

    belongs_to :product, class_name: 'Spree::Product'
    belongs_to :user, class_name: Spree.user_class.to_s
    belongs_to :order, class_name: 'Spree::Order', inverse_of: :account_subscriptions

    scope :canceled, -> { where(state: :canceled) }
    scope :expiring_on, ->(date) { where('date(end_datetime) = ?', date.to_date) }

    state_machine :state, initial: :active do
      event(:cancel){ transition to: :canceled, if: :allow_cancel? }
    end

    def order_number
      order ? order.number : ''
    end

    def ended?
      end_datetime? && DateTime.now > end_datetime
    end

    def canceled?
      state.try(:to_sym) == :canceled
    end

    def allow_cancel?
      !canceled?
    end

    def description
      if user.present?
        "#{user.email} expires #{end_datetime} token: #{token}"
      else
        "expires #{end_datetime} token: #{token}"
      end
    end

    def self.subscribe!(opts)
      opts.to_options!.assert_valid_keys(:email, :user, :product, :start_datetime, :end_datetime, :order, :num_seats, :is_renewal, :renewal_date)
      existing_subscription = where(email: opts[:email],
        user_id: opts[:user].id,
        product_id: opts[:product].id,
        order: opts[:order].id,
        num_seats: opts[:num_seats]
      ).first

      if existing_subscription
        renew_subscription(existing_subscription, opts[:end_datetime])
      else
        new_subscription(opts[:email], opts[:user], opts[:product], opts[:start_datetime],
          opts[:end_datetime], opts[:order], opts[:num_seats], opts[:is_renewal], opts[:renewal_date])
      end
    end

    def self.new_subscription(email, user, product, start_datetime, end_datetime, order, num_seats, is_renewal, renewal_date)
      create do |s|
        s.email               = email
        s.user_id             = user.id
        s.product_id          = product.id
        s.order_id            = order.id
        s.start_datetime      = start_datetime
        s.end_datetime        = end_datetime
        s.num_seats           = num_seats
        s.is_renewal          = is_renewal
        s.renewal_date        = renewal_date
      end
    end

    def self.renew_subscription(old_subscription, new_end_datetime)
      old_subscription.update_attribute(:end_datetime, new_end_datetime)
      old_subscription
    end

  end
end
