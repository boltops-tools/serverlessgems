require "open-uri"

module Jets::Gems::Extract
  class Base
    class NotFound < RuntimeError; end

    attr_reader :project_root
    def initialize(name, options={})
      @name = name
      @options = options

      @downloads_root = options[:downloads_root] || "/tmp/jets/#{Jets.config.project_name}/serverlessgems"
    end

    def clean_downloads(folder)
      path = "#{@downloads_root}/downloads/#{folder}"
      say "Removing cache: #{path}"
      FileUtils.rm_rf(path)
    end

    # Using ` > /dev/null 2>&1` to suppress stderr message:
    #
    #    lchmod (file attributes) error: Function not implemented
    #
    def unzip(zipfile_path, parent_folder_dest)
      sh("cd #{parent_folder_dest} && unzip -qo #{zipfile_path} > /dev/null 2>&1")
    end

    def sh(command)
      say "=> #{command}".color(:green)
      success = system(command)
      abort("Command Failed #{command}") unless success
      success
    end

    # Returns the dest path
    def download_file(url, dest)
      if File.exist?(dest)
        say "File already downloaded #{dest}"
        return dest
      end

      say "Downloading..."
      FileUtils.mkdir_p(File.dirname(dest)) # ensure parent folder exists

      File.open(dest, 'wb') do |saved_file|
        URI.open(url, 'rb') do |read_file|
          saved_file.write(read_file.read)
        end
      end
      dest
    end

    @@log_level = :info # default level is :info
    # @@log_level = :debug # uncomment to debug
    def log_level=(val)
      @@log_level = val
    end

    def say(message, level=:info)
      enabled = @@log_level == :debug || level == :debug
      puts(message) if enabled
    end
  end
end
