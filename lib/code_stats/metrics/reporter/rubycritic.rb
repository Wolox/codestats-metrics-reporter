require 's3_uploader'
require 'pathname'

module CodeStats
  module Metrics
    module Reporter
      class Rubycritic
        class << self
          def generate_data(metric, config_store)
            @config_store = config_store
            @metric = metric
            return unless valid_uploader_data?
            {
              metric_name: @metric.data['name'],
              value: generate_score_file['score'],
              url: uploader_url,
              minimum: @metric.data['minimum']
            }
          end

          private

          def uploader_url
            "https://s3.amazonaws.com/#{bucket}/rubycritic/#{project}/#{branch}/overview.html"
          end

          def generate_score_file
            uploader = build_uploader
            base_dir = Pathname.new(@metric.data['report_dir'])
            uploader.upload(File.realpath(base_dir).to_s, bucket)
            json = JSON.parse(File.read(base_dir.join('report.json')))
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
             destination_dir: "rubycritic/#{project}/#{branch}",
             region: @metric.data['uploader_region']
            })
          end

          def project
            Ci.data(@config_store.ci)[:repository_name]
          end

          def branch
            Ci.data(@config_store.ci)[:branch]
          end

          def bucket
            @metric.data['uploader_bucket']
          end
        end
      end
    end
  end
end
