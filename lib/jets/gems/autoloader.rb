require "zeitwerk"

# Make sure to define module Jets in case serverlessgems is loaded before jets
module Jets
  module Gems
    class Autoloader
      class Inflector < Zeitwerk::Inflector
        def camelize(basename, _abspath)
          map = {cli: "CLI", version: "VERSION"}
          map[basename.to_sym] || super
        end
      end

      class << self
        def setup
          loader = Zeitwerk::Loader.new
          loader.inflector = Inflector.new
          lib = File.expand_path("../..", __dir__)
          loader.push_dir(lib) # lib
          loader.ignore("#{lib}/serverlessgems.rb")
          loader.setup
        end
      end
    end
  end
end
