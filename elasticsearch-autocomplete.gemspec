# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/autocomplete/version'

Gem::Specification.new do |spec|
  spec.name          = "elasticsearch-autocomplete"
  spec.version       = Elasticsearch::Autocomplete::VERSION
  spec.authors       = ["s.podlecki"]
  spec.email         = ["s.podlecki@gmail.com"]

  spec.summary       = %q{Autocomplete Helpers and Builder}
  spec.description   = %q{Include autocomplete into your project. Base capability can perform multiple queries per request.}
  spec.homepage      = "https://github.com/spodlecki/elasticsearch-autocomplete"

  spec.files         = Dir["{app,config,db,lib,vendor}/**/*", "Rakefile", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '> 3.2.0'
  spec.add_dependency 'elasticsearch'
  spec.add_dependency 'elasticsearch-model'
  spec.add_dependency 'elasticsearch-rails'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
