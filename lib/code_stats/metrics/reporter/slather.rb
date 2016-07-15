require 's3_uploader'
require 'pathname'
require 'oga'

module CodeStats
  module Metrics
    module Reporter
      class Slather
        class << self
          def generate_data(metric, config_store)
            @config_store = config_store
            @metric = metric
            return if upload_report? && !valid_uploader_data?
            {
              metric_name: @metric.data['name'],
              value: generate_score_file,
              url: (uploader_url if upload_report?),
              minimum: @metric.data['minimum']
            }
          end

          private

          def uploader_url
            "https://s3.amazonaws.com/#{bucket}/slather/#{project}/#{id}/index.html"
          end

          def generate_score_file
            base_dir = Pathname.new(@metric.data['report_dir'])
            build_uploader.upload(File.realpath(base_dir).to_s, bucket) if upload_report?
            html = File.read(base_dir.join('index.html'))
            parse_coverage(html)
          end

          def upload_report?
            @metric.data['upload_report']
          end

          def parse_coverage(html)
            coverage_header = Oga.parse_html(html).xpath('html/body/div/div/h4').text
            total_coverage = coverage_header.match(/\d+.\d+/)
            total_coverage ? total_coverage[0].to_f : 0.0
          end

          def valid_uploader_data?
            %w(uploader_key uploader_secret uploader_region uploader_bucket).all? do |value|
              !@metric.data[value].nil?
            end
          end

          def build_uploader
            S3Uploader::Uploader.new({
             s3_key: @metric.data['uploader_key'],
             s3_secret: @metric.data['uploader_secret'],
             destination_dir: "slather/#{project}/#{id}",
             region: @metric.data['uploader_region']
            })
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
