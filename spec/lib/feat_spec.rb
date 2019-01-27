require 'spec_helper'
require 'securerandom'

RSpec.describe Feat do
  before(:all) do
    @app_id = SecureRandom.hex

    Feat.configure do |config|
      config.app_id = @app_id
    end
  end

  let(:awesome_times) { rand(1..10) }
  let(:awesome_user_ids) { (1..10).to_a.sample(2) }
  let(:meh_times) { rand(1..10) }
  let(:meh_user_ids) { (1..10).to_a.sample(2) }

  before(:each) do
    Redis.new.flushall
  end

  it 'caches and uploads feats to FeatHQ' do
    awesome_times.times { subject.perform(:awesome_feature) }

    awesome_user_ids.each_with_index do |uid, idx|
      (idx + 1).times { subject.perform(:awesome_feature, for: uid) }
    end

    meh_times.times { subject.perform(:meh_feature) }

    meh_user_ids.each_with_index do |uid, idx|
      (idx + 1).times { subject.perform(:meh_feature, for: uid) }
    end

    expected_date = Time.now.utc.strftime('%Y%m%d')

    expected_body = {
      expected_date => {
        awesome_feature: {
          '' => awesome_times,
          awesome_user_ids[0] => 1,
          awesome_user_ids[1] => 2,
        },
        meh_feature: {
          '' => meh_times,
          meh_user_ids[0] => 1,
          meh_user_ids[1] => 2,
        }
      }
    }.to_json

    stub_request(:post, 'https://www.feathq.com/api/record')
      .with(
        body: expected_body,
        headers: {
          'Content-Type' => 'application/json',
          'App-Id' => @app_id
        }
      ).to_return(status: 200)

    subject.record
  end
end