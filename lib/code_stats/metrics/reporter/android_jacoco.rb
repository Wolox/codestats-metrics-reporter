require 'json'

module CodeStats
  module Metrics
    module Reporter
      class AndroidJacoco
        class << self
          def generate_data(metric, config_store)
            @config_store = config_store
            @metric = metric
            {
              metric_name: metric.data['name'],
              value: parse_coverage,
              minimum: metric.data['minimum'],
              url: url
            }
          end

          private

          def parse_coverage
            doc = Oga.parse_xml(File.read(@metric.data['location']))
            covered = parse_covered(doc)
            covered * 100 / (parse_missed(doc) + covered)
          end

          def parse_missed(doc)
            doc.xpath('/report/counter').map { |c| c.get('missed').to_f }.inject(0, :+)
          end

          def parse_covered(doc)
            doc.xpath('/report/counter').map { |c| c.get('covered').to_f }.inject(0, :+)
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
