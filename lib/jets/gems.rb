require "jets"

$:.unshift(File.expand_path("../../", __FILE__))
require "jets/gems/autoloader"
Jets::Gems::Autoloader.setup

require "memoist"
require "yaml"

module Jets
  module Gems
    def ruby_folder
      major, minor, _ = RUBY_VERSION.split(".")
      [major, minor, "0"].join(".") # 2.5.1 => 2.5.0
    end

    extend self
  end
end
