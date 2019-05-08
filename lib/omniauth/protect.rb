require 'base64'
require 'rack'

module Omniauth
  module Protect
    class ConfigException < Exception
    end

    @config = {
      message: '',
      paths: []
    }

    def self.config
      @config
    end

    # Adds / to the paths
    def self.configure
      raise ConfigException.new('message must be specified') if config[:message].empty?
      raise ConfigException.new('paths must be specified') if config[:paths].empty?

      config[:paths].each do |path|
        next if path[-1] == '/'

        config[:paths] << "#{path}/"
      end
    end
  end
end

require 'omniauth/protect/middleware'