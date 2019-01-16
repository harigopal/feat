$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'feat/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'feat'
  spec.version     = Feat::VERSION
  spec.authors     = ['Hari Gopal']
  spec.email       = 'mail@harigopal.in'
  spec.homepage    = 'https://www.github.com/harigopal/feat'
  spec.summary     = 'Track feature use in your Rails application with feat'
  spec.description = 'Unused features have a complexity cost. Feat allows you to easily record and explore feature use in a Rails application.'
  spec.license     = 'MIT'

  spec.files = Dir['lib/**/*', 'LICENSE', 'README.md']
end
