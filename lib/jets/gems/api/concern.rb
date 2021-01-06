class Jets::Gems::Api
  module Concern
    def api
      Jets::Gems::Api.new
    end
  end
end
