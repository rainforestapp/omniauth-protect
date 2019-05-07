RSpec.describe Omniauth::Protect do
  it 'has a version number' do
    expect(Omniauth::Protect::VERSION).not_to be nil
  end

  it 'has a default config' do
    expect(Omniauth::Protect.config).to eq (
      {message: 'CSRF detected, Access Denied', paths: ['/auth/github', '/auth/github/']}
    )
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
end
