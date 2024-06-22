module Jets::Gems
  class Exist
    include Jets::Gems::Api::Concern

    # gem_name IE: nokogiri-1.1.1
    def check(gem_name)
      api.check_exist(gem_name: gem_name) # data = {"exist": ..., "available"}
    rescue SocketError, OpenURI::HTTPError, OpenSSL::SSL::SSLError
      {"exist" => false, :gem_name => gem_name, :available => []}
    end
  end
end
