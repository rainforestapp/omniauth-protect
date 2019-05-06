
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "omniauth/protect/version"

Gem::Specification.new do |spec|
  spec.name          = "omniauth-protect"
  spec.version       = Omniauth::Protect::VERSION
  spec.authors       = ["Serdar Dogruyol"]
  spec.email         = ["serdar@rainforestqa.com"]
  spec.license       = "MIT"

  spec.summary       = %q{Protect Omniauth from request phase CSRF}
  spec.description   = %q{Protects your Rails app from Omniauth request phase CSRF vulnerability.}
  spec.homepage      = "https://github.com/rainforestapp/omniauth-protect"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'actionpack'
  spec.add_runtime_dependency 'rack'

  spec.add_development_dependency "bundler", '~> 1.10'
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rspec_junit_formatter'
end
