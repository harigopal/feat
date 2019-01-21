require 'spec_helper'

RSpec.describe Feat do
  before(:all) do
    Feat.configure do |configuration|
      configuration.redis = { host: 'localhost', post: 6379 }
    end
  end

  before do
    Redis.new.flushall
  end

  describe '.perform' do
    it 'caches feats to Redis' do
      redis = Redis.new

      expect do
        subject.perform(:awesome_feat)
      end.to(change { redis.keys('feat*').count }.from(0).to(2))

      cached_feats = redis.smembers('feat:cache')

      expect(cached_feats.count).to eq(1)

      key = "feat:#{Time.now.utc.strftime('%Y%m%d')}:awesome_feat"
      expect(cached_feats.first).to eq(key)

      expect(redis.get(key)).to eq('1')

      subject.perform(:awesome_feat)

      expect(redis.get(key)).to eq('2')
    end
  end
end