Gem::Specification.new do |spec|
  spec.name = 'ai-agents'
  spec.version = '0.12.0'
  spec.authors = ['Shivam Mishra']
  spec.summary = 'Ruby AI Agents SDK (YARA compatibility patch)'
  spec.homepage = 'https://github.com/chatwoot/ai-agents'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'
  spec.files = Dir['lib/**/*.rb'] + ['LICENSE']
  spec.require_paths = ['lib']
  spec.add_dependency 'ruby_llm', '~> 2.0.0'
end
