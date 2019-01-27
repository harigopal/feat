require 'redis'
require 'connection_pool'

require_relative 'feat/configuration'
require_relative 'feat/cache'
require_relative 'feat/uploader'

module Feat
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Feat::Configuration.new
      yield configuration
    end

    def perform(feat, **opts)
      audience = opts[:for] || ''
      Feat::Cache.new(feat, audience).cache_to_redis
    end

    def record
      Feat::Uploader.new.upload_to_server
    end

    def redis
      @redis ||= ConnectionPool.new(configuration.connection_pool) do
        Redis.new(configuration.redis)
      end
    end
  end
end