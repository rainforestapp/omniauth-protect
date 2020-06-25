# frozen_string_literal: true

module Omniauth
  module Protect
    class Validator
      def initialize(env, encoded_masked_token)
        @session = env['rack.session']
        @encoded_masked_token = encoded_masked_token
      end

      # This is mostly taken & adapted from Rails' action_controller/metal/request_forgery_protection.rb
      # We copy code from Rails in such a horrible manner because Rails doesn't really expose CSRF protection
      def valid_csrf_token?
        begin
          masked_token = Base64.urlsafe_decode64(@encoded_masked_token)
        rescue ArgumentError # @encoded_masked_token is invalid Base64
          return false
        end

        token_length = ActionController::RequestForgeryProtection::AUTHENTICITY_TOKEN_LENGTH

        if masked_token.length == token_length * 2
          csrf_token = unmask_token(masked_token, token_length)

          real_token = real_csrf_token(token_length)
          global_token = global_csrf_token(real_token)

          compare_tokens(csrf_token, real_token) || compare_tokens(csrf_token, global_token)
        end
      end

      private

      def compare_tokens(token, other)
        ActiveSupport::SecurityUtils.fixed_length_secure_compare(token, other)
      end

      def unmask_token(masked_token, token_length)
        one_time_pad = masked_token[0...token_length]
        encrypted_csrf_token = masked_token[token_length..-1]
        xor_byte_strings(one_time_pad, encrypted_csrf_token)
      end

      def xor_byte_strings(s1, s2) # :doc:
        s2 = s2.dup
        size = s1.bytesize
        i = 0
        while i < size
          s2.setbyte(i, s1.getbyte(i) ^ s2.getbyte(i))
          i += 1
        end
        s2
      end

      def real_csrf_token(token_length)
        @session[:_csrf_token] ||= SecureRandom.urlsafe_base64(token_length, padding: false)
        Base64.urlsafe_decode64(@session[:_csrf_token])
      end

      def global_csrf_token(real_token)
        OpenSSL::HMAC.digest(
          OpenSSL::Digest::SHA256.new,
          real_token,
          '!real_csrf_token'
        )
      end
    end
  end
end
