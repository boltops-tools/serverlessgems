lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jets/gems/version"

Gem::Specification.new do |spec|
  spec.name = "serverlessgems"
  spec.version = Jets::Gems::VERSION
  spec.authors = ["Tung Nguyen"]
  spec.email = ["tongueroo@gmail.com"]

  spec.summary = "Client Library works with Serverless Gems API for Jets Ruby Serverless Framework"
  spec.homepage = "https://github.com/boltops-tools/serverlessgems"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gems"
  spec.add_dependency "memoist"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
