module Jets::Gems
  class Registered
    include Jets::Gems::Api::Concern

    def all
      data = api.registered_gems
      data["gems"]
    rescue SocketError, OpenURI::HTTPError, OpenSSL::SSL::SSLError
      []
    end
  end
end
