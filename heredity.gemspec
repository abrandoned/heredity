# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heredity/version'

Gem::Specification.new do |gem|
  gem.name          = "heredity"
  gem.version       = Heredity::VERSION
  gem.authors       = ["Brandon Dewitt"]
  gem.email         = ["brandonsdewitt@gmail.com"]
  gem.description   = %q{provides class inheritable attributes outside of rails and other gem/frameworks}
  gem.summary       = %q{inherit class instance variables}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  ##
  # Development dependencies
  #
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec-pride"
  gem.add_development_dependency "pry-nav"
  gem.add_development_dependency "simplecov"
end
