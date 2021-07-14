module Jets::Gems
  class Exist
    include Jets::Gems::Api::Concern

    # We check all the availability before even downloading so we can provide a
    # full list of gems they might want to research all at once instead of incrementally
    #
    # Examples:
    #
    #   check(single_gem)
    #   check(list, of, gems)
    def check(*gem_names)
      gem_names = gem_names.flatten
      exists = gem_names.inject({}) do |hash, gem_name|
        exist = gem_exist?(gem_name)
        hash[gem_name] = exist
        hash.merge(hash)
      end

      exists.values.all? {|v| v } # all_exist
    end

    def gem_exist?(gem_name)
      data = api.check_exist(gem_name: gem_name)
      data["exist"]
    rescue SocketError, OpenURI::HTTPError, OpenSSL::SSL::SSLError
      false
    end
  end
end