module Feat
  class Cache
    def initialize(feat)
      @feat = feat
    end

    def cache_to_redis
      Feat.redis.with do |conn|
        conn.sadd('feat:cache', namespaced_feat)
        conn.incr(namespaced_feat)
      end
    end

    private

    def namespaced_feat
      @namespaced_feat ||= "feat:#{Time.now.utc.strftime('%Y%m%d')}:#{@feat}"
    end
  end
end