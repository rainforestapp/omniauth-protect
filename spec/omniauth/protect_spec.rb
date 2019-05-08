RSpec.describe Omniauth::Protect do
  it 'has a version number' do
    expect(Omniauth::Protect::VERSION).not_to be nil
  end

  it 'can configure' do
    Omniauth::Protect.config[:paths] = ['/auth/twitter', '/auth/google']
    Omniauth::Protect.config[:message] = 'Custom CSRF message'
    Omniauth::Protect.configure

    expect(Omniauth::Protect.config).to eq(
      {
        message: 'Custom CSRF message',
        paths: ['/auth/twitter', '/auth/google', '/auth/twitter/', '/auth/google/']
      }
      )
  end

  context 'exceptions' do
    before do
      Omniauth::Protect.config[:paths] = []
      Omniauth::Protect.config[:message] = ''
    end

    it 'raises on empty message' do
      Omniauth::Protect.config[:paths] = ['/auth/twitter', '/auth/google']
      expect{
        Omniauth::Protect.configure
      }.to raise_exception(Omniauth::Protect::ConfigException, 'message must be specified')
    end

    it 'raises on empty paths' do
      Omniauth::Protect.config[:message] = 'Custom CSRF message'
      expect{
        Omniauth::Protect.configure
      }.to raise_exception(Omniauth::Protect::ConfigException, 'paths must be specified')
    end
  end
end
