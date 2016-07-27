require 'json'

module CodeStats
  module Metrics
    module Reporter
      class Simplecov
        class << self
          def generate_data(metric, _config_store)
            json = JSON.parse(File.read('coverage/.last_run.json'))
            code_coverage = json['result']['covered_percent']
            {
              metric_name: metric.data['name'],
              value: code_coverage,
              minimum: metric.data['minimum']
            }
          end
        end
      end
    end
  end
end
