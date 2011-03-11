#ＵＴＦ
#http://rubist.blog77.fc2.com/blog-entry-159.html

# GetText&#29992;&#12395;&#19979;&#35352;&#65297;&#34892;&#12434;&#36861;&#21152;
$KCODE = "UTF8"
require 'jcode'
# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
  ENV['RAILS_ENV'] ||= 'production'

require 'rubygems'
gem 'sqlite3-ruby', '=1.2.1'
# ENV['RAILS_ENV'] ||= 'development'
# Specifies gem version of Rails to use when vendor/rails is not present

# RAILS_GEM_VERSION = '2.0.1' unless defined? RAILS_GEM_VERSION
# RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
config.gem "prawn"
if Gem::VERSION >= "1.3.6"
    module Rails
        class GemDependency
            def requirement
                r = super
                (r == Gem::Requirement.default) ? nil : r
            end
        end
    end
end

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_bb_session',
    :secret      => '0d561b6c87d16dd72ef3192729e6830f27cac9a0d2f7bcaa7252576977dceaa3ecd1d8478540c2d24623d6c7f54f20fc8a04f2c0ef9f4a3fa26711380d8524c4'
    }
  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
   config.action_controller.session_store = :active_record_store
  
  # 2008.09.25 changed session store destination
  #config.action_controller.session_store = :p_store
    
  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

# THIS PART BLOW ADDED FROM 2.1 VERSION-----------------
  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'Tokyo'

  # GetText&#29992;&#12395;&#19979;&#35352;&#65297;&#34892;&#12434;&#36861;&#21152;

=begin additional configurations to be added here ikuro
=end


end

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"

#ActionMailer::Base.default_charset = "iso-2022-jp"

ActionMailer::Base.smtp_settings = {
  :address => "localhost",  
  :port => 25,
  :domain => "taiju.railsplayground.net"
# :authentication => :login,
# :user_name => "<em>＜ユーザー名＞</em>",
# :password => "<em>＜パスワード＞</em>"
  }
=begin 
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
:address => "localhost", # instead of "smtp.yourdomain.com",
:port => 25,
:domain => "yourdomain.com",
:authentication => :login,
:user_name => "user_name",
:password => "password"
}
=end

