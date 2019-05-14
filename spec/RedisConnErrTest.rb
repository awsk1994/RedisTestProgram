# encoding: UTF-8

require 'rspec'
require './lib/RedisHelper'
require 'json'
require 'redis'

def get_wrong_redis_connection()
  server = "localhost"
  port = "1234" # wrong port number to test failure to connect to redis.
  redis_conn = Redis.new(host: server, port: port)	# Connection is not made yet.
  redis_conn
end

describe 'Get wrong redis connection' do
  it 'should trigger Redis::BaseConnectionError' do
    expect {
      get_wrong_redis_connection().flushall()
    }.to raise_error(Redis::BaseConnectionError)
  end
end

