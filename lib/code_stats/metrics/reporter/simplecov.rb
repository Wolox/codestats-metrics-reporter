require 'json'

module CodeStats
  module Metrics
    module Reporter
      class Simplecov
        class << self
          def generate_data(metric, _config_store)
            return empty_value unless File.directory?('coverage') && File.file?('coverage/.last_run.json')
            json = JSON.parse(File.read('coverage/.last_run.json'))
            code_coverage = json['result']['covered_percent']
            {
              metric_name: metric.data['name'],
              value: code_coverage,
              minimum: metric.data['minimum']
            }
          end

          def empty_value
            {
              metric_name: metric.data['name'],
              value: 0,
              minimum: metric.data['minimum']
            }
          end
        end
      end
    end
  end
end
