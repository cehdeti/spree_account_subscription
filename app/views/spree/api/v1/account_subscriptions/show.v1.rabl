object @account_subscription

attributes :email, :state, :token, :num_seats, :order_number, :is_renewal,
           :renewal_date
attributes id: :subscription, start_datetime: :start, end_datetime: :end
glue :product do
  attributes :sku
  attributes id: :product
end
glue :user do
  attributes id: :user
end
