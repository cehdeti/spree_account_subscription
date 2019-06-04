object @account_subscription

attributes :email, :state, :token, :num_seats, :seats_taken, :order_number,
           :is_renewal, :renewal_date
attributes id: :subscription, start: :start_datetime, end: :end_datetime
glue @account_subscription.product do
  attributes :sku
  attributes id: :product
end
glue @account_subscription.user do
  attributes id: :user
end
