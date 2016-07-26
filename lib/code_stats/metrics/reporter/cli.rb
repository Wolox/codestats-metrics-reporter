require 'httparty'

module CodeStats
  module Metrics
    module Reporter
      class CLI
        SUCCESS_CODE = 0
        ERROR_CODE = 2
        attr_reader :config_store

        def initialize
          @config_store = ConfigStore.new
        end

        def run
          config_store.metrics_configs.each do |metric_config|
            process_and_report_metric(metric_config, config_store)
          end
          SUCCESS_CODE
        rescue StandardError => e
          puts "Message: #{e.message} - Backtrace: #{e.backtrace}"
          ERROR_CODE
        end

        private

        def process_and_report_metric(metric_config, config_store)
          puts "Processing #{metric_config.data['name']} metric"
          data = generate_metric_data(metric_config, config_store)
          return if data.nil?
          post_report_metric(data)
          puts "Sending #{metric_config.data['name']} data"
        end

        def generate_metric_data(metric_config, config_store)
          Object.const_get(
            "CodeStats::Metrics::Reporter::#{generate_class_name(metric_config)}"
          ).generate_data(metric_config, config_store)
        end

        def generate_class_name(metric_config)
          metric_config.data['metric'].split('_').map(&:capitalize).join
        end

        def post_report_metric(data)
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
