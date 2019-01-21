module Feat
  class Configuration
    attr_accessor :redis
    attr_accessor :server
    attr_accessor :connection_pool

    def initialize
      @redis = {}
      @server = { url: 'https://api.feathq.com/record' }
      @connection_pool = { size: 2, timeout: 2 }
    end
  end
end