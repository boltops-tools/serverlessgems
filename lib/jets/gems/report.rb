require "net/http"

module Jets::Gems
  class Report
    include Jets::Gems::Api::Concern

    def initialize(options = {})
      @options = options
    end

    def report(gems)
      threads = []
      gems.each do |gem_name|
        threads << Thread.new do
          api.report_missing(gem_name: gem_name)
        end
      end
      # Wait for request to finish because the command might finish before
      # the Threads even send the request. So we join them just case
      threads.each(&:join)
    end
  end
end
