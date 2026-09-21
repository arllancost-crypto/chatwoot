Gem::Specification.new do |spec|
  spec.name = 'devise-secure_password'
  spec.version = '2.0.1'
  spec.authors = ['Mark Eissler']
  spec.summary = 'Devise password policy enforcement (YARA Rails compatibility build)'
  spec.homepage = 'https://github.com/chatwoot/devise-secure_password'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7'
  spec.files = Dir['lib/**/*', 'app/**/*', 'config/**/*'] + ['LICENSE.txt']
  spec.require_paths = ['lib']
  spec.add_dependency 'devise', '>= 4.0.0', '< 5.0.0'
  spec.add_dependency 'railties', '>= 5.0.0', '< 8.2.0'
end
