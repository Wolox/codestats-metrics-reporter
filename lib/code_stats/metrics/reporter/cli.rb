require 'httparty'

module CodeStats
  module Metrics
    module Reporter
      class CLI
        attr_reader :config_store

        def initialize
          @config_store = ConfigStore.new
        end

        def run
          config_store.metrics_configs.each do |metric_config|
            puts "Processing #{metric_config.data['name']} metric"
            data = Object.const_get(
              "CodeStats::Metrics::Reporter::#{generate_class_name(metric_config)}"
            ).generate_data(metric_config, config_store)
            next if data.nil?
            report_metric(data)
            puts "Sending #{metric_config.data['name']} data"
          end
          return 0
        rescue Exception => e
          puts e.message
          puts e.backtrace
          return 2
        end

        private

        def generate_class_name(metric_config)
          metric_config.data['metric'].split('_').map(&:capitalize).join
        end

        def report_metric(data)
          HTTParty.post(
            "#{config_store.url}api/v1/metrics",
            body: metric_data(data),
            headers: { 'Authorization' => config_store.token.to_s }
          )
        end

        def metric_data(data)
          {
            metric: {
              branch_name: Ci.data(config_store.ci)[:branch],
              name: data[:metric_name],
              value: data[:value],
              url: data[:url],
              minimum: data[:minimum],
              pull_request_number: Ci.data(config_store.ci)[:pull_request]
            }
          }
        end
      end
    end
  end
end
