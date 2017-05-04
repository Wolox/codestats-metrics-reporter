require 's3_uploader'
require 'pathname'
require 'json'

module CodeStats
  module Metrics
    module Reporter
      class Swiftlint
        class << self
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
            upload_report
            code_quality
          end

          def code_quality
            base_dir = Pathname.new(@metric.data['report_dir'])
            html = File.read(base_dir.join('index.html'))
            
            total_warnings = Oga.parse_html(html).xpath('html/body/table[2]/tbody/tr[2]/td[2]').text.to_i
            total_errors = Oga.parse_html(html).xpath('html/body/table[2]/tbody/tr[3]/td[2]').text.to_i

            total = 100
            total -= total_errors * 100   # In case there are errors, code quality MUST be 0.
            total -= total_warnings * 2   # Each warning substracts 2 from max.
            [0, total].max
          end

          # Uploading methods

          def upload_report
            build_uploader.upload(File.realpath(@metric.data['report_dir']).to_s, bucket) if upload_report?
          end

          def build_uploader
            S3Uploader::Uploader.new(s3_key: @metric.data['uploader_key'],
                                     s3_secret: @metric.data['uploader_secret'],
                                     destination_dir: "swiftlint/#{project}/#{id}",
                                     region: @metric.data['uploader_region'])
          end

          def upload_report?
            @metric.data['upload_report']
          end

          def url
            "https://s3.amazonaws.com/#{bucket}/swiftlint/#{project}/#{id}/index.html"
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
