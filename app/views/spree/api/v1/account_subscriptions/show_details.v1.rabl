object @account_subscription

node(:subscription) { @account_subscription.id }
node(:user) { @account_subscription.user.id }
node(:email) { @account_subscription.email }
node(:state) { @account_subscription.state }
node(:start) { @account_subscription.start_datetime }
node(:end) { @account_subscription.end_datetime }
node(:token) { @account_subscription.token }
node(:num_seats) {@account_subscription.num_seats}
node(:seats_taken) {@account_subscription.seats_taken }
node(:order_number) {@account_subscription.order_number }
node(:is_renewal) { @account_subscription.is_renewal }
node(:renewal_date) { @account_subscription.renewal_date }
node(:product) { @account_subscription.product.id }
node(:sku) { |a| @account_subscription.product.sku }
