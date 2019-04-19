require 'redis'
require 'date'
require 'json'

class RedisDeleteHashCronJob
  attr_accessor :redis_conn

  def initialize(server, port)
    @redis_conn = Redis.new(host: server, port: port)
  end

  def deleteExpired(key, expireKey)
    fields = @redis_conn.hkeys(key)

    fields.each do |field|
      hashStr = @redis_conn.hget(key, field)

      unless hashStr.nil?
        hash = JSON.parse(hashStr)
        expireDate = DateTime.parse(hash[expireKey])

        if expireDate < DateTime.now()
          puts "Delete client id = " + hash['id'].to_s
          @redis_conn.hdel(key, hash['id'])
        end
      end
    end
  end
end