module CodeStats
  module Metrics
    module Reporter
      class Ci
        def self.data(service)
          respond_to?(service.downcase) ? send(service.downcase) : {}
        end

        def self.travis
          {
            name:             'travis-ci',
            build_identifier: ENV['TRAVIS_JOB_ID'],
            pull_request:     ENV['TRAVIS_PULL_REQUEST'],
            repository_name:  ENV['TRAVIS_REPO_SLUG'].split('/')[1]
          }
        end

        def self.circleci
          {
            name:             'circleci',
            build_identifier: ENV['CIRCLE_BUILD_NUM'],
            branch:           ENV['CIRCLE_BRANCH'],
            repository_name:  ENV['CIRCLE_PROJECT_REPONAME']
          }
        end

        def self.jenkins
          {
            name:             'jenkins',
            build_identifier: ENV['BUILD_NUMBER'],
            branch:           ENV['ghprbSourceBranch'],
            repository_name:  ENV['JOB_NAME']
          }
        end
      end
    end
  end
end
