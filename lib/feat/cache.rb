module Feat
  class Cache
    def initialize(feat, audience)
      @feat = feat
      @audience = audience
    end

    def cache_to_redis
      Feat.redis.with do |conn|
        conn.sadd('feat:cached_dates', date)
        conn.sadd("feat:feats_on_date:#{date}", @feat)
        conn.hincrby("feat:#{namespaced_feat}", @audience, 1)
      end
    end

    private

    def date
      @date ||= Time.now.utc.strftime('%Y%m%d')
    end

    def namespaced_feat
      @namespaced_feat ||= "#{date}:#{@feat}"
    end
  end
end