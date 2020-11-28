$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'admin/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'admin'
  spec.version     = Admin::VERSION
  spec.authors     = ['From Scratch Co., Ltd.']
  spec.email       = ['staff@f-scratch.com']
  spec.homepage    = 'https://github.com/f-scratch/zelda-template4th'
  spec.summary     = 'ZeldaTemplate4th Admin'
  spec.description = 'ZeldaTemplate4th Admin'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGemspec.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushespec.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'pundit'
  spec.add_dependency 'rails', '~> 6.0.3', '>= 6.0.3.2'

  # fs-zeldapluginの名残
  spec.add_dependency 'autoprefixer-rails', '~>8.2.0'
  spec.add_dependency 'bootstrap', '= 4.0.0.alpha5'
  spec.add_dependency 'custard'
  spec.add_dependency 'font-awesome-rails'
  spec.add_dependency 'tether-rails'

  spec.add_development_dependency 'sqlite3'
end
