# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_filterbubble_run_session',
  :secret      => '4f485abc6be0a9862dde788c3315e1b32574b9d4555d24d7136ee8f4d3f7f70d361aa65a7eb1aaead257e68d711ebd6264849b07e911d512517cc8863a20e0cd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
