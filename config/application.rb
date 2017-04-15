require_relative 'boot'

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Arbitrage
  class Application < Rails::Application
    config.cache_store = :memory_store, {size: 64.megabytes}

    # controller = Daemons::Rails::Monitoring.controller('poller.rb')
    # if controller.status != :running
    #   controller.start
    # end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
