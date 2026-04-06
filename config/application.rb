require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Trainitems
  class Application < Rails::Application
    config.load_defaults 8.1

    config.time_zone = 'Brussels'
  end
end
