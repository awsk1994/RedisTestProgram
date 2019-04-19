require 'redis'

class RedisHelper
	def self.checkConnection(redis_conn)	# self.method = public static method
		begin
			redis_conn.ping				# Check Redis server is up.
		rescue StandardError => e
			return false
		else
			return true
		end
	end
end