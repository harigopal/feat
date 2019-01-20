module Feat
  class Recorder
    def initialize(redis, configuration)
      @redis = redis
      @configuration = configuration
    end

    def execute
      feats = @redis.smembers('feat:record').map do |feat_record|
        record = feat_record.match(/feat:(?<date>\d{8}):(?<feat>[\w]+\z)/)

        {
          feat: record[:feat],
          date: record[:date],
          count: @redis.get(feat_record)
        }
      end

      Feat::Client.new(@configuration).record(feats)
    end
  end
end