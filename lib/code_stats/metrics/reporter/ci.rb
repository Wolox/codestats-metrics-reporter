module CodeStats
  module Metrics
    module Reporter
      class Ci
        def self.data(service)
          if service == 'TRAVIS'
            {
              name:             'travis-ci',
              branch:           ENV['TRAVIS_BRANCH'],
              build_identifier: ENV['TRAVIS_JOB_ID'],
              pull_request:     ENV['TRAVIS_PULL_REQUEST']
            }
          elsif service == 'CIRCLECI'
            {
              name:             'circleci',
              build_identifier: ENV['CIRCLE_BUILD_NUM'],
              branch:           ENV['CIRCLE_BRANCH'],
              commit_sha:       ENV['CIRCLE_SHA1'],
              repository_name:  ENV['CIRCLE_PROJECT_REPONAME']
            }
          elsif service == 'JENKINS_URL'
            {
              name:             'jenkins',
              build_identifier: ENV['BUILD_NUMBER'],
              build_url:        ENV['BUILD_URL'],
              branch:           ENV['GIT_BRANCH'],
              commit_sha:       ENV['GIT_COMMIT']
            }
          else
            {}
          end
        end
      end
    end
  end
end
