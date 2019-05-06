require 'base64'
require 'rack'

module Omniauth
  module Protect
    VERSION = '1.0.0'

    @configuration = {
      message: 'CSRF detected, Access Denied',
      paths: ['/auth/github']
    }

    def self.configuration
      @configuration
    end

    # Adds / to the paths
    def self.configure
      configuration[:paths].each do |path|
        next if path[-1] == '/'

        configuration[:paths] << "#{path}/"
      end
    end
  end
end

Omniauth::Protect.configure

require "omniauth/protect/middleware"