module CodeStats
  module Metrics
    module Reporter
      class MetricConfig
        attr_reader :data
        def initialize(args = {})
          @data = args
        end
      end
    end
  end
end
