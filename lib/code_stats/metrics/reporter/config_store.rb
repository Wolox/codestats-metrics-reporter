module CodeStats
  module Metrics
    module Reporter
      class ConfigStore
        attr_reader :metrics_configs, :ci, :token, :url
        def initialize
          configs = ConfigLoader.load_file
          @metrics_configs = configs[:metrics_configs]
          @ci = configs['ci']
          @token = configs['token']
          @url = configs['url']
        end
      end
    end
  end
end
