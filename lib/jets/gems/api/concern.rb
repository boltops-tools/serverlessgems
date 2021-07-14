# Need 'open-uri' for exist.rb and regsitered.rb which uses
# rescue SocketError, OpenURI::HTTPError, OpenSSL::SSL::SSLError
require 'open-uri'

class Jets::Gems::Api
  module Concern
    def api
      Jets::Gems::Api.new
    end
  end
end
