require 'base64'
require 'rack'

module Omniauth
  module Protect
    @config = {
      message: 'CSRF detected, Access Denied',
      paths: ['/auth/github']
    }

    def self.config
      @config
    end

    # Adds / to the paths
    def self.configure
      config[:paths].each do |path|
        next if path[-1] == '/'

        config[:paths] << "#{path}/"
      end
    end
  end
end

Omniauth::Protect.configure

require 'omniauth/protect/middleware'