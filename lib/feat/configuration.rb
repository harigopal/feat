module Feat
  class Configuration
    attr_accessor :some_config

    def initialize
      @some_config = 'default_value'
    end
  end
end