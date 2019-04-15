# encoding: UTF-8

require 'rspec'
require '../lib/RedisHelper'

describe 'Basic Get/Set' do
  before(:each){
    @redisHelper = RedisHelper.new('localhost', '6379')
    @request_id = 'request-id-1'
  }

  it 'should set (foo:bar) and get it back.' do
    k,v = "foo", "bar"
    @redisHelper.set(k, v, @request_id)
    retValue = @redisHelper.get(k, @request_id)
    expect(retValue).to eq v
  end
end