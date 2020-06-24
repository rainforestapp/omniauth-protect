# frozen_string_literal: true

require 'omniauth/protect/validator'

module Omniauth
  module Protect
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        if !Omniauth::Protect.config[:paths].include?(env['PATH_INFO'])
          @app.call(env)
        else
          access_denied = [403, { 'Content-Type' => 'text/plain'}, [ Omniauth::Protect.config[:message] ] ]
          return access_denied if env['REQUEST_METHOD'] != 'POST'

          req = Rack::Request.new(env)
          encoded_masked_token = req.params['authenticity_token']

          return access_denied if !encoded_masked_token

          Validator.new(env, encoded_masked_token).valid_csrf_token? ? @app.call(env) : access_denied
        end
      end
    end
  end
end
