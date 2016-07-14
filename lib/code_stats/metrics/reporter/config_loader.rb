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
            load_default_file
            load_user_file
            @user_data || @default_data
          end

          def load_default_file
            default_file = load_yml_file(DEFAULT_FILE)
            return if default_file.nil?
            @default_data = default_file['config'].merge(metrics_configs: [])
            load_default_metrics_configs(default_file['metrics'])
          end

          def load_user_file
            user_file = load_yml_file(File.realpath(FILE_NAME))
            return if user_file.nil?
            @user_data = @default_data.merge(user_file['config'])
            @user_data[:metrics_configs] = []
            load_user_metrics_configs(user_file['metrics'])
          end

          def load_yml_file(path)
            return unless File.exist?(path)
            yaml_code = IO.read(path, encoding: 'UTF-8')
            YAML.load(ERB.new(yaml_code).result)
          end

          def load_default_metrics_configs(metrics)
            metrics.each do |metric, metric_data|
              @default_data[:metrics_configs] << MetricConfig.new(
                metric_data.merge('metric' => metric)
              )
            end
          end

          def load_user_metrics_configs(metrics)
            @default_data[:metrics_configs].each do |metric_default_config|
              user_metric_data = metrics[metric_default_config.data['metric']] unless metrics.nil?
              if metric_default_config.data['enabled'] && (metrics.nil? || user_metric_data.nil?)
                @user_data[:metrics_configs] << metric_default_config
              elsif !metrics.nil? && !user_metric_data.nil? && user_metric_data['enabled']
                @user_data[:metrics_configs] << MetricConfig.new(
                  metric_default_config.data.merge(user_metric_data)
                )
              end
            end
          end
        end
      end
    end
  end
end
