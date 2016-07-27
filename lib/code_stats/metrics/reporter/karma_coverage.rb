require 'json'

module CodeStats
  module Metrics
    module Reporter
      class KarmaCoverage
        class << self
          def generate_data(metric, config_store)
            @metric = metric
            @config_store = config_store
            {
              metric_name: @metric.data['name'],
              value: parse_coverage,
              minimum: @metric.data['minimum'],
              url: url
            }
          end

          private

          def parse_coverage
            xml = File.read(@metric.data['location'])
            Oga.parse_xml(xml).xpath('coverage')[0].get('line-rate').to_f * 100
          end

          def url
            return if invalid_url_params?
            "#{build_base_url}/#{repository_name}/#{build_identifier}/#{build_report_file_url}"
          end

          def invalid_url_params?
            build_base_url.nil? ||
              build_identifier.nil? ||
              repository_name.nil? ||
              build_report_file_url.nil?
          end

          def build_base_url
            @metric.data['build_base_url']
          end

          def build_report_file_url
            @metric.data['build_report_file_url']
          end

          def build_identifier
            Ci.data(@config_store.ci)[:build_identifier]
          end

          def repository_name
            Ci.data(@config_store.ci)[:repository_name]
          end
        end
      end
    end
  end
end
