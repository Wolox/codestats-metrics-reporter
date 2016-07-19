require 'json'

module CodeStats
  module Metrics
    module Reporter
      class AndroidQuality
        class << self
          EXTENSIONS = ['xml', 'java']

          def generate_data(metric, config_store)
            @config_store = config_store
            @metric = metric
            {
              metric_name: metric.data['name'],
              value: parse_quality,
              minimum: metric.data['minimum'],
              url: url
            }
          end

          private

          def parse_quality
            xml = File.read(@metric.data['location'])
            doc = Oga.parse_xml(xml)
            issues = parse_issues(doc)

            issues_map = source_files.map { |f| { file: f, issues: [] } }

            # Add issues to each file
            issues.each do |issue|
              source = issues_map.find { |i| i[:file] == issue[:location] }
              source[:issues].push(issue) if source
            end

            # Give a score to each file
            issues_map.each do |f|
              f[:score] = f[:issues].inject(100) { |score, i| score - i[:priority]**2 }
              f[:score] = 0 if f[:score] < 0
            end

            # Return the average of scores
            issues_map.inject(0) { |sum, f| sum + f[:score] } / issues_map.size
          end

          def parse_issues(doc)
            doc.xpath('//issue').map do |i|
              {
                location: i.xpath('location').first.get('file'),
                severity: i.get('severity'),
                priority: i.get('priority').to_i,
                category: i.get('category'),
                summary: i.get('summary')
              }
            end
          end

          def source_files
            files = Dir.glob("#{source_dir}/**/src/**/*.{#{EXTENSIONS.join(',')}}")
            files + Dir.glob("#{source_dir}/**/*.gradle")
          end

          def source_dir
            @metric.data['source_dir']
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
