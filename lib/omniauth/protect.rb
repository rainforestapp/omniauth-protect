require "rack"
require "base64"

module Omniauth
  module Protect
    VERSION = "1.0.0"

    @configuration = {
      :message => 'CSRF detected, Access Denied',
      :paths => ['/auth/github', '/auth/github/']
    }

    def self.configuration
      @configuration
    end
  end
end

require "omniauth/protect/middleware"