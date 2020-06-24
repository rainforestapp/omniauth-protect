# frozen_string_literal: true

require 'omniauth/protect/middleware'

RSpec.describe Omniauth::Protect::Middleware do
  let(:app) do
    ->(env) { [200, env, 'app'] }
  end
  let(:mock_env) do
    Rack::MockRequest.env_for(
      url,
      'REQUEST_METHOD' => 'POST',
      params: { 'authenticity_token' => 'dummy' }
    )
  end
  let(:url) { 'https://myapp.dev/auth/github' }
  let(:middleware) { described_class.new(app) }

  describe '#call' do
    before do
      Omniauth::Protect.config[:paths] = ['/auth/github']
      Omniauth::Protect.config[:message] = 'CSRF detected, Access Denied'
      Omniauth::Protect.configure
    end

    context '/auth/github' do
      context 'renders 200' do
        it 'valid csrf' do
          allow_any_instance_of(Omniauth::Protect::Validator).to receive(:valid_csrf_token?).and_return(true)
          result = middleware.call(mock_env)

          expect(result[0]).to eq 200
        end

        it 'different path' do
          url = 'https://myapp.dev/auth/non-github'

          result = middleware.call(Rack::MockRequest.env_for(url))

          expect(result[0]).to eq 200
        end
      end

      context 'renders 403' do
        it 'for non-POST request method' do
          result = middleware.call(Rack::MockRequest.env_for(url, 'REQUEST_METHOD' => 'GET'))

          expect(result).to eq [403, { 'Content-Type' => 'text/plain' }, ['CSRF detected, Access Denied']]
        end

        it 'invalid csrf token' do
          result = middleware.call(mock_env)

          expect(result).to eq [403, { 'Content-Type' => 'text/plain' }, ['CSRF detected, Access Denied']]
        end
      end
    end
  end
end
