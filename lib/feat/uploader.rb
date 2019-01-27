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
          feats_on_date = conn.smembers("feat:feats_on_date:#{cached_date}")

          dates[cached_date] = feats_on_date.each_with_object({}) do |feat, feats|
            performances = conn.hgetall("feat:#{cached_date}:#{feat}")

            feats[feat] = performances.each_with_object({}) do |(audience, performance_count), with_count_as_number|
              with_count_as_number[audience] = performance_count.to_i
            end
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