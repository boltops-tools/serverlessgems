require "aws-sdk-core"

class Jets::Gems::Api
  module Core
    extend Memoist

    # Always translate raw json response to ruby Hash
    def request(klass, path, data = {})
      url = url(path)
      req = build_request(klass, url, data)
      resp = http.request(req) # send request
      load_json(url, resp)
    end

    def build_request(klass, url, data = {})
      data = global_data.merge(data)
      if klass == Net::HTTP::Get
        url += "?#{URI.encode_www_form(data)}" if data.any?
      end
      req = klass.new(url) # url includes query string and uri.path does not, must used url
      set_headers!(req)
      if [Net::HTTP::Delete, Net::HTTP::Patch, Net::HTTP::Post, Net::HTTP::Put].include?(klass)
        text = JSON.dump(data)
        req.body = text
        req.content_length = text.bytesize
      end
      req
    end

    def set_headers!(req)
      req["Authorization"] = token if token
      req["x-account"] = account if account
      req["Content-Type"] = "application/vnd.api+json"
    end

    def global_data
      Jets.boot
      params = {}
      params[:jets_env] = Jets.env.to_s
      params[:jets_extra] = Jets.extra.to_s if Jets.extra
      params[:name] = Jets.project_namespace
      params[:region] = Jets.aws.region
      params[:account] = Jets.aws.account
      params[:project_id] = Jets.config.project_name
      params[:serverlessgems_version] = Jets::Gems::VERSION
      params[:jets_version] = Jets::VERSION
      params[:ruby_version] = RUBY_VERSION
      params[:ruby_folder] = Jets::Gems.ruby_folder
      params
    end

    def token
      Jets::Gems::Config.instance.data["key"]
    end

    def load_json(url, res)
      uri = URI(url)
      if ok?(res.code)
        JSON.load(res.body)
      else
        puts "Error: Non-successful http response status code: #{res.code}"
        puts "headers: #{res.each_header.to_h.inspect}"
        puts "ServerlessGems API #{url}" if ENV["SG_DEBUG"]
        raise "ServerlessGems API called failed: #{uri.host}"
      end
    end

    # Note: 422 is Unprocessable Entity. This means an invalid data payload was sent.
    # We want that to error and raise
    def ok?(http_code)
      http_code =~ /^20/ || http_code =~ /^40/
    end

    def http
      uri = URI(endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = http.read_timeout = 30
      http.use_ssl = true if uri.scheme == "https"
      http
    end
    memoize :http

    # API does not include the /. IE: https://app.terraform.io/api/v2
    def url(path)
      "#{endpoint}/#{path}"
    end

    def get(path, data = {})
      request(Net::HTTP::Get, path, data)
    end

    def post(path, data = {})
      request(Net::HTTP::Post, path, data)
    end

    def patch(path, data = {})
      request(Net::HTTP::Patch, path, data)
    end

    def delete(path, data = {})
      request(Net::HTTP::Delete, path, data)
    end

    def account
      sts.get_caller_identity.account
    rescue
      nil
    end
    memoize :account

    def sts
      Aws::STS::Client.new
    end
    memoize :sts
  end
end
