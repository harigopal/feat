module Feat
  class Uploader
    def upload_to_server
      feats = load_feats_from_redis
      send_feats_to_server(feats)
    end

    private

    def load_feats_from_redis
      Feat.redis.with do |conn|
        conn.smembers('feat:cache').map do |feat_record|
          record = feat_record.match(/feat:(?<date>\d{8}):(?<feat>[\w]+\z)/)

          {
            feat: record[:feat],
            date: record[:date],
            count: conn.get(feat_record).to_i
          }
        end
      end
    end

    def send_feats_to_server(feats)
      uri = URI(Feat.configuration.server[:url])
      Net::HTTP.post(uri, feats.to_json, 'Content-Type' => 'application/json')
    end
  end
end