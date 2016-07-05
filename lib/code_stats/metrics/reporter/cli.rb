require 's3_uploader'
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
              "CodeStats::Metrics::Reporter::#{metric_config.data['metric'].capitalize}"
            ).generate_data(metric_config, config_store)
            next if data.nil?
            report_metric(data)
            puts "Sending #{metric_config.data['name']} data"
          end
          return 0
        # rescue Exception => e
          # stderr = StringIO.new
          # stderr.puts e.message
          # stderr.puts e.backtrace
          return 2
        end

        def report_metric(data)
          HTTParty.post(
            "#{config_store.url}api/v1/metrics",
            body: metric_data(data),
            headers: { 'Authorization' => config_store.token }
          )
        end

        def metric_data(data)
          {
            metric: {
              branch_name: Ci.data(config_store.ci)[:branch],
              name: data[:metric_name],
              value: data[:value],
              url: data[:url],
              minimum: data[:minimum]
            }
          }
        end
      end
    end
  end
end
