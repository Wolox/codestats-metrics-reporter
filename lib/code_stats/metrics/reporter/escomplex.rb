require 'json'

module CodeStats
  module Metrics
    module Reporter
      class Escomplex
        class << self
          MAINTAINABILITY_MAX = 171.0
          def generate_data(metric, config_store)
            @config_store = config_store
            @metric = metric
            {
              metric_name: @metric.data['name'],
              minimum: @metric.data['minimum'],
              value: maintainability,
              url: url
            }
          end

          private

          def url
            reutrn if build_base_url.nil? || build_identifier.nil? || repository_name.nil?
            "#{build_base_url}/#{repository_name}/#{build_identifier}"
          end

          def build_base_url
            @metric.data['build_base_url']
          end

          def build_identifier
            Ci.data(@config_store.ci)[:build_identifier]
          end

          def repository_name
            Ci.data(@config_store.ci)[:repository_name]
          end

          # Maintanibility is measured from 0 to MAINTAINABILITY_MAX. higher is better
          def maintainability
            json = JSON.parse(File.read(@metric.data['location']))
            json['maintainability'] * 100 / MAINTAINABILITY_MAX
          end
        end
      end
    end
  end
end
