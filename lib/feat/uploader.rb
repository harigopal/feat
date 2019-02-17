module Feat
  class Uploader
    def upload_to_server
      feats = load_feats_from_redis
      send_feats_to_server(feats)
    end

    private

    def load_feats_from_redis
      Feat.redis.with do |conn|
        conn.smembers('feat:cached_dates').each_with_object({}) do |cached_date, dates|
          feats_on_date = conn.hgetall("feat:feats_on_date:#{cached_date}")

          dates[cached_date] = feats_on_date.each_with_object({}) do |(feat, performances), feats|
            audience = conn.smembers("feat:audience:#{cached_date}:#{feat}")

            feats[feat] = {
              performances: performances.to_i,
              audience: audience
            }
          end
        end
      end
    end

    def send_feats_to_server(feats)
      uri = URI(Feat.configuration.server[:url])
      app_id = Feat.configuration.app_id
      Net::HTTP.post(uri, feats.to_json, 'Content-Type' => 'application/json', 'App-Id' => app_id)
    end
  end
end