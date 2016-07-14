module CodeStats
  module Metrics
    module Reporter
      class Ci
        def self.data(service)
          if service == 'TRAVIS'
            {
              name:             'travis-ci',
              build_identifier: ENV['TRAVIS_JOB_ID'],
              pull_request:     ENV['TRAVIS_PULL_REQUEST'],
              repository_name:  ENV['TRAVIS_REPO_SLUG'].split('/')[1]
            }
          elsif service == 'CIRCLECI'
            {
              name:             'circleci',
              build_identifier: ENV['CIRCLE_BUILD_NUM'],
              branch:           ENV['CIRCLE_BRANCH'],
              repository_name:  ENV['CIRCLE_PROJECT_REPONAME']
            }
          elsif service == 'JENKINS'
            {
              name:             'jenkins',
              build_identifier: ENV['BUILD_NUMBER'],
              branch:           ENV['ghprbSourceBranch'],
              repository_name:  ENV['JOB_NAME']
            }
          else
            {}
          end
        end
      end
    end
  end
end
