# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'code_stats/metrics/reporter/version'

Gem::Specification.new do |spec|
  spec.name          = "codestats-metrics-reporter"
  spec.version       = CodeStats::Metrics::Reporter::VERSION
  spec.authors       = ["Esteban Pintos"]
  spec.email         = ["esteban.pintos@wolox.com.ar"]

  spec.summary       = %q{Report metrics to CodeStats}
  spec.homepage      = %q{https://github.com/Wolox/codestats-metrics-reporter}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']
  spec.executables   = Dir['bin/*'].map{ |f| File.basename(f) }

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "httparty"
  spec.add_development_dependency "s3_uploader"
end
