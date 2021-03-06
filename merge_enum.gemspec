# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'merge_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "merge_enum"
  spec.version       = MergeEnum::VERSION
  spec.authors       = ["brightgenerous"]
  spec.email         = ["katou.akihiro@gmail.com"]
  spec.summary       = %q{Merge those like Enumerable}
  spec.description   = %q{Merge those like Enumerable}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 0"

  spec.add_development_dependency 'rspec', '~> 3.0.0.rc1'
  spec.add_development_dependency 'simplecov', "~> 0"

  spec.add_development_dependency 'rspec_term', '~> 0.3', '>= 0.3.0'
end
