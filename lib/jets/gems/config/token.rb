class Jets::Gems::Config
  class Token
    def key
      data["key"]
    end

    def data
      load_yaml("#{ENV["HOME"]}/.jets/config.yml")
    end

    # Ensure a Hash is returned
    def load_yaml(path)
      return {} unless File.exist?(path)

      data = YAML.load_file(path)
      if data.is_a?(Hash)
        data
      else
        puts "WARN: #{path} is not in the correct format. Loading an empty hash.".color(:yellow)
        {}
      end
    end
  end
end
