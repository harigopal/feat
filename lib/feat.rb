module Feat
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Feat::Configuration.new
      yield configuration
    end

    def perform(feat)
      namespaced_feat = namespace_feat(feat)
      redis.sadd('feat:record', namespaced_feat)
      redis.incr(namespaced_feat)
    end

    def record
      Feat::Recorder.new(redis, configuration.server).execute
    end

    private

    def namespace_feat(feat)
      "feat:#{Time.now.utc.strftime('%Y%m%d')}:#{feat}"
    end

    def redis
      @redis ||= Redis.new(configuration.redis)
    end
  end
end