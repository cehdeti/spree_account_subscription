object @account_subcription

node(:subscription) { @account_subcription.id }
node(:user) { @account_subcription.user.id }
node(:email) { @account_subcription.email }
node(:state) { @account_subcription.state }
node(:start) { @account_subcription.start_datetime }
node(:end) { @account_subcription.end_datetime }
node(:token) { @account_subcription.token }
node(:num_seats) {@account_subcription.num_seats}
node(:seats_taken) {@account_subcription.seats_taken }
node(:order_number) {@account_subcription.order_number }
node(:is_renewal) { @account_subcription.is_renewal }
node(:renewal_date) { @account_subcription.renewal_date }