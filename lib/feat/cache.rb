module Feat
  class Cache
    def initialize(feat, audience)
      @feat = feat
      @audience = audience
    end

    def cache_to_redis
      Feat.redis.with do |conn|
        conn.sadd('feat:cached_dates', date)
        conn.hincrby("feat:feats_on_date:#{date}", @feat, 1)
        conn.sadd("feat:audience:#{namespaced_feat}", @audience) if @audience
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