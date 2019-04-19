# encoding: UTF-8

require 'rspec'
require 'json'
require 'redis'
require 'date'
require './lib/RedisDeleteHashCronJob'

describe 'RedisDeleteHashCronJobTest' do
  describe 'Create clients' do
    before(:all){
      @cron_job = RedisDeleteHashCronJob.new("localhost", "6379")
      @cron_job.redis_conn.flushall()

      @key = "client"

      @client_1 = {"id" => 1, "expire" => DateTime.now.next_day(-3).to_s}
      @cron_job.redis_conn.hset(@key, @client_1['id'], @client_1.to_json)

      @client_2 = {"id" => 2, "expire" => DateTime.now.next_day(-2).to_s}
      @cron_job.redis_conn.hset(@key, @client_2['id'], @client_2.to_json)

      @client_3 = {"id" => 3, "expire" => DateTime.now.next_day(3).to_s}
      @cron_job.redis_conn.hset(@key, @client_3['id'], @client_3.to_json)

      @client_4 = {"id" => 4, "expire" => DateTime.now.next_day(4).to_s}
      @cron_job.redis_conn.hset(@key, @client_4['id'], @client_4.to_json)
    }

    it 'should have client 1' do
      expect(@cron_job.redis_conn.hget(@key, @client_1['id'])).not_to eq(nil)
    end

    it 'should have client 2' do
      expect(@cron_job.redis_conn.hget(@key, @client_2['id'])).not_to eq(nil)
    end

    it 'should have client 3' do
      expect(@cron_job.redis_conn.hget(@key, @client_3['id'])).not_to eq(nil)
    end

    it 'should have client 4' do
      expect(@cron_job.redis_conn.hget(@key, @client_4['id'])).not_to eq(nil)
    end
  end

  describe 'Delete Expired Test' do
    before(:all){
      @cron_job = RedisDeleteHashCronJob.new("localhost", "6379")
      @cron_job.redis_conn.flushall()

      @key = "client"

      @client_1 = {"id" => 1, "expire" => DateTime.now.next_day(-3).to_s}
      @cron_job.redis_conn.hset(@key, @client_1['id'], @client_1.to_json)

      @client_2 = {"id" => 2, "expire" => DateTime.now.next_day(-2).to_s}
      @cron_job.redis_conn.hset(@key, @client_2['id'], @client_2.to_json)

      @client_3 = {"id" => 3, "expire" => DateTime.now.next_day(3).to_s}
      @cron_job.redis_conn.hset(@key, @client_3['id'], @client_3.to_json)

      @client_4 = {"id" => 4, "expire" => DateTime.now.next_day(4).to_s}
      @cron_job.redis_conn.hset(@key, @client_4['id'], @client_4.to_json)

      @cron_job.deleteExpired(@key, "expire")
    }

    it 'should not have client 1' do
      expect(@cron_job.redis_conn.hget(@key, @client_1['id'])).to eq(nil)
    end

    it 'should not have client 2' do
      expect(@cron_job.redis_conn.hget(@key, @client_2['id'])).to eq(nil)
    end

    it 'should have client 3' do
      expect(@cron_job.redis_conn.hget(@key, @client_3['id'])).not_to eq(nil)
    end

    it 'should have client 4' do
      expect(@cron_job.redis_conn.hget(@key, @client_4['id'])).not_to eq(nil)
    end
  end
end