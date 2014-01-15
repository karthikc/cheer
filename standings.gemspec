# -*- encoding: utf-8 -*-
require File.expand_path('../lib/standings/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Eos Software Systems Pvt Ltd"]
  gem.email         = ["info@eossys.com"]
  gem.description   = %q{This gem helps you to create a leader board, and also useful to find ranking of users according to columns specified}
  gem.summary       = %q{This gem helps you to create a leader board, and also useful to find ranking of users according to columns specified}
  gem.homepage      = "https://github.com/eossys/standings"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "standings"
  gem.require_paths = ["lib"]
  gem.version       = Standings::VERSION

  # Add development dependencies
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'sqlite3'
  gem.add_dependency 'activerecord', '>= 3.0'
end
