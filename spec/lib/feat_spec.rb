require 'spec_helper'

RSpec.describe Feat do
  before(:all) do
    Feat.configure { |_c| }
  end

  before(:each) do
    redis.flushall
  end

  let(:redis) { Redis.new }
  let(:awesome_times) { rand(1..10) }
  let(:meh_times) { rand(1..10) }

  it 'caches and uploads feats to FeatHQ' do
    awesome_times.times { subject.perform(:awesome_feature) }
    meh_times.times { subject.perform(:meh_feature) }

    expected_date = Time.now.utc.strftime('%Y%m%d')

    expected_body = [
      { feat: :meh_feature, date: expected_date, count: meh_times },
      { feat: :awesome_feature, date: expected_date, count: awesome_times }
    ].to_json

    stub_request(:post, 'https://www.feathq.com/api/record')
      .with(
        body: expected_body,
        headers: {
          'Content-Type' => 'application/json'
        }
      ).to_return(status: 200)

    subject.record
  end
end