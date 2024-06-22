module Jets::Gems
  class Api
    include Core

    def endpoint
      ENV["SG_API"] || Jets.config.gems.source || "https://api.serverlessgems.com/api/v1"
    end

    def download_url(gem_name:, project:)
      get("gem/download", gem_name: gem_name, ruby_folder: ruby_folder, project: project)
    end

    def check_exist(gem_name:)
      get("gem/exist", gem_name: gem_name, ruby_folder: ruby_folder)
    end

    def report_missing(gem_name:)
      get("report/missing", gem_name: gem_name, ruby_folder: ruby_folder)
    end

    def registered_gems
      get("gems/registered")
    end

    def ruby_folder
      Jets::Gems.ruby_folder
    end
  end
end
