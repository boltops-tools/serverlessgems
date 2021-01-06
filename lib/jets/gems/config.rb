require "singleton"

module Jets::Gems
  class Config
    include Singleton
    extend Memoist

    def data
      Token.new.data
    end
    memoize :data
  end
end
