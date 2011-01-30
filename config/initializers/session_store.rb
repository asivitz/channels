# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_channels_session',
  :secret      => 'fda722e1401df5b27db5aba8711e1bc9e8dcfb742965cdee42d2601bd52da828d44157366913ccc74eac9d116333669336d64380903eb4c1176132e2aa1bd793'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
