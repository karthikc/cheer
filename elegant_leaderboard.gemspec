# -*- encoding: utf-8 -*-
require File.expand_path('../lib/elegant_leaderboard/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'elegant-leaderboard'
  gem.version       = ElegantLeaderboard::VERSION
  gem.authors       = ['Eos Software Systems Pvt Ltd']
  gem.email         = ['info@eossys.com']
  gem.description   = %q{A ruby gem to quickly add rankings & leaderboards to existing models in a rails application}
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/eossys/elegant-leaderboard'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  # Runtime Dependencies
  gem.add_runtime_dependency 'activerecord', '>= 3.0'

  # Development dependencies
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'sqlite3', '~> 1.3.8'
end
