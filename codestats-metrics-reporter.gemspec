# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'code_stats/metrics/reporter/version'

Gem::Specification.new do |spec|
  spec.name          = 'codestats-metrics-reporter'
  spec.version       = CodeStats::Metrics::Reporter::VERSION
  spec.authors       = ['Esteban Pintos']
  spec.email         = ['esteban.pintos@wolox.com.ar']

  spec.summary       = %q{Report metrics to CodeStats}
  spec.homepage      = %q{https://github.com/Wolox/codestats-metrics-reporter}
  spec.description   = %q{Gem that will let you control your code quality by reporting custom metrics to [CodeStats](https://github.com/Wolox/codestats)}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']
  spec.executables   = Dir['bin/*'].map{ |f| File.basename(f) }

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_dependency 'rake', '>= 0.8'
  spec.add_dependency 'httparty'
  spec.add_dependency 's3_uploader'
  spec.add_dependency 'oga'
end
