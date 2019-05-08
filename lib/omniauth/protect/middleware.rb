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

          valid_csrf_token?(env, encoded_masked_token) ? @app.call(env) : access_denied
        end
      end
      # This is mostly taken & adapted from https://github.com/rails/rails/blob/v4.2.0/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L276
      def valid_csrf_token?(env, encoded_masked_token)
        begin
          masked_token = Base64.strict_decode64(encoded_masked_token)
        rescue ArgumentError # encoded_masked_token is invalid Base64
          return false
        end

        token_length = ActionController::RequestForgeryProtection::AUTHENTICITY_TOKEN_LENGTH
        if masked_token.length == token_length * 2
          one_time_pad = masked_token[0...token_length]
          encrypted_csrf_token = masked_token[token_length..-1]
          csrf_token = one_time_pad.bytes.zip(encrypted_csrf_token.bytes).map { |(c1, c2)| c1 ^ c2 }.pack('c*')
          session = session(env)
          session[:_csrf_token] ||= SecureRandom.base64(token_length)
          real_csrf_token = Base64.strict_decode64(session[:_csrf_token])
          ActiveSupport::SecurityUtils.secure_compare(csrf_token, real_csrf_token)
        end
      end

      def session(env)
        env['rack.session']
      end
    end
  end
end