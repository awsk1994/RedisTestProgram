# encoding: UTF-8

require 'rspec'
require './lib/RedisHelper'
require 'json'
require 'redis'

def get_redis_conn()
  server = "localhost"
  port = "6379"
  redis_conn = Redis.new(host: server, port: port)	# Connection is not made yet.
  redis_conn
end

describe 'RedisMethodsTest' do
  before(:all){
    @redis_connection = get_redis_conn()
  }
  
  describe 'set()' do
    before(:all){
      @key, @value = "foo", "bar"

      if RedisHelper.checkConnection(@redis_connection)
        @redis_connection.flushall()
        @redis_connection.set(@key, @value)
      else
        fail "no redis connection"
      end
    }

    it 'should get "bar" back.' do
      expect(@redis_connection.get(@key)).to eq(@value)
    end
  end

  describe 'set() with ttl ' do
    before(:all){
      @key, @value, @ttl = "foo", "bar", 5

      if RedisHelper.checkConnection(@redis_connection)
        @redis_connection.flushall()
        @redis_connection.set(@key, @value)
        @redis_connection.expire(@key, @ttl)
      else
        fail "no redis connection"
      end
    }

    it 'should get value immediately' do
      expect(@redis_connection.get(@key)).to eq(@value)
    end

    it 'should get value after 3 seconds (before it expires)' do
      sleep(3)
      expect(@redis_connection.get(@key)).to eq(@value)
    end

    it 'should not get value after 6 seconds (after it expires)' do
      sleep(6)
      expect(@redis_connection.get(@key)).to eq(nil)
    end
  end

  describe 'hget() on nil result' do
    before(:all){
      if RedisHelper.checkConnection(@redis_connection)
        @redis_connection.flushall()
      else
        fail "no redis connection"
      end

      @key, @field, @value = "client", "1", "-1"
    }

    it 'should get nil' do
      expect(@redis_connection.hget(@key, @field)).to eq(nil)
    end
  end

  describe 'hset/hget where field is string' do
    before(:all){
      @key = "client"
      @field = "1"
      @value = {"name" => "some name", "pw" => 123}

      if RedisHelper.checkConnection(@redis_connection)
        @redis_connection.flushall()
        @redis_connection.hset(@key, @field, @value.to_json)
      else
        fail "no redis connection"
      end
    }

    it 'should have correct name' do
      client = JSON.parse(@redis_connection.hget(@key, @field))
      retrieved_name = client['name']
      expect(retrieved_name).to eq(@value['name'])
    end

    it 'should have correct pw' do
      client = JSON.parse(@redis_connection.hget(@key, @field))
      retrieved_pw = client['pw']
      expect(retrieved_pw).to eq(@value['pw'])
    end
  end

  describe 'hset/hget where field is int' do
    before(:all){
      @key = "client"
      @field = 1
      @value = {"name" => "some name", "pw" => 123}

      if RedisHelper.checkConnection(@redis_connection)
        @redis_connection.flushall()
        @redis_connection.hset(@key, @field, @value.to_json)
      else
        fail "no redis connection"
      end
    }

    it 'should have correct name' do
      client = JSON.parse(@redis_connection.hget(@key, @field))
      retrieved_name = client['name']
      expect(retrieved_name).to eq(@value['name'])
    end

    it 'should have correct pw' do
      client = JSON.parse(@redis_connection.hget(@key, @field))
      retrieved_pw = client['pw']
      expect(retrieved_pw).to eq(@value['pw'])
    end
  end
end