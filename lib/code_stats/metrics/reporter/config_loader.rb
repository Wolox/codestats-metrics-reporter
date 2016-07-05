require 'yaml'
require 'erb'

module CodeStats
  module Metrics
    module Reporter
      class ConfigLoader
        FILE_NAME = '.codestats.yml'.freeze
        CODE_STATS_HOME = File.realpath(File.join(File.dirname(__FILE__), '..', '..', '..', '..'))
        DEFAULT_FILE = File.join(CODE_STATS_HOME, 'config', 'default.yml')

        class << self
          def load_file
            yaml_code = IO.read(DEFAULT_FILE, encoding: 'UTF-8')
            hash = YAML.load(ERB.new(yaml_code).result)
            data = hash['config'].merge(metrics_configs: [])
            load_metrics_configs(hash, data)
          end

          def load_metrics_configs(hash, data)
            hash['metrics'].each do |metric, metric_data|
              if metric_data['enabled'] == true
                data[:metrics_configs] << MetricConfig.new(metric_data.merge('metric' => metric))
              end
            end
            data
          end
        end
      end
    end
  end
end
