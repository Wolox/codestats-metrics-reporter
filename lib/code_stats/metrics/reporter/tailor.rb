require 'json'

module CodeStats
  module Metrics
    module Reporter
      class Tailor
        class << self
          EXTENSIONS = %w(swift).freeze

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
            violations = parse_violations(parse_json)
            violations_map = initialize_violations_map(parse_json)
            filled_violations_map = fill_violations_map(violations, violations_map)
            average_scores = average_scores(score_files(filled_violations_map))
            upload_report
            average_scores
          end

          def parse_json
            JSON.parse(File.read(@metric.data['location']))
          end

          def parse_violations(json_file)
            violations = json_file['files'].map do |file|
              file['violations'].map do |violation|
                { 
                  location: file['path'], 
                  rule: violation['rule'] 
                }
              end
            end
            violations.flatten
          end

          def initialize_violations_map(json_file)
            files = json_file['files'].map do |file|
              {
                file: file['path'],
                violations: []
              }
            end
          end

          # Add violations to each file
          def fill_violations_map(violations, violations_map)
            violations.each do |each|
              violation = violations_map.find { |i| each[:location] == i[:file] }
              violation[:violations].push(each[:rule]) if violation
            end
            violations_map
          end

          # Give a score to each file
          def score_files(violations_map)
            violations_map.each do |each|
              each[:score] = each[:violations].inject(100) { |a, e| a - 5 }
              each[:score] = 0 if each[:score] < 0
              each.delete(:violations)
            end
            violations_map
          end

          # Return the average of scores
          def average_scores(violations_map)
            violations_map.inject(0) { |a, e| a + e[:score] } / violations_map.size
          end

          # Uploading methods

          def upload_report
            build_uploader.upload(File.realpath(@metric.data['report_dir']).to_s, bucket) if upload_report?
          end

          def build_uploader
            S3Uploader::Uploader.new(s3_key: @metric.data['uploader_key'],
                                     s3_secret: @metric.data['uploader_secret'],
                                     destination_dir: "tailor/#{project}/#{id}",
                                     region: @metric.data['uploader_region'])
          end

          def upload_report?
            @metric.data['upload_report']
          end

          def url
            "https://s3.amazonaws.com/#{bucket}/tailor/#{project}/#{id}/index.html"
          end

          def project
            Ci.data(@config_store.ci)[:repository_name]
          end

          def id
            Ci.data(@config_store.ci)[:branch] || Ci.data(@config_store.ci)[:pull_request]
          end

          def bucket
            @metric.data['uploader_bucket']
          end
        end
      end
    end
  end
end
