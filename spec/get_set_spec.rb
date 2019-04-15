# encoding: UTF-8

require 'rspec'
require './lib/RedisHelper'

describe 'Basic Get/Set' do
  before(:each){
    @redisHelper = RedisHelper.new('localhost', '6379')
    @request_id = 'request-id-1'
  }

  describe 'set' do
    before(:eac){
      k,v = "foo", "bar"
      @redisHelper.set(k, v, @request_id)
    }

    it 'should get "bar" back.' do
      expect(@redisHelper.get("foo", @request_id)).to eq("bar")
    end
  end

  describe 'set with ttl' do
    before(:each){
      k,v, ttl = "foo", "bar", 5
      @redisHelper.set_with_expire_secs(k, v, ttl, @request_id)
    }

    it 'should get value immediately' do
      expect(@redisHelper.get("foo", @request_id)).to eq("bar")
    end

    it 'should get value after 3 seconds (before it expires)' do
      sleep(3)
      expect(@redisHelper.get("foo", @request_id)).to eq("bar")
    end

    it 'should not get value after 6 seconds (after it expires)' do
      sleep(6)
      expect(@redisHelper.get("foo", @request_id)).to eq(nil)
    end
  end
end