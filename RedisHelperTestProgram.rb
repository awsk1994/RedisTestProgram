require './RedisHelper.rb'

redisHelper = RedisHelper.new('localhost', '6379')
request_id = 'request_id_1'

puts "\n=== Test 1 (basic set/get)==="
puts "set foo:bar"
redisHelper.set('foo', 'bar', request_id)
puts "getFoo == bar: #{redisHelper.get('foo', request_id) === 'bar'}"
puts "resp: #{redisHelper.get('foo', request_id)}"

puts "\n=== Test 2 (basic set/get)==="
puts "set foo:bar2"
redisHelper.set('foo', 'bar2', request_id)
puts "getFoo == bar: #{redisHelper.get('foo', request_id) === 'bar2'}"
puts "resp: #{redisHelper.get('foo', request_id)}"

puts "\n=== Test 3 (set with ttl)==="
puts "set foo:bar3 with ttl 5 seconds"
redisHelper.set_with_expire('foo', 'bar3', '5', request_id)
puts "immediately get foo: getFoo == bar3: #{redisHelper.get('foo', request_id) === 'bar3'}"
puts "resp: #{redisHelper.get('foo', request_id)}"

sleep(1)
puts "after 1 second get foo: getFoo == bar3: #{redisHelper.get('foo', request_id) === 'bar3'}"

sleep(3)
puts "after 4 second get foo: getFoo == bar3: #{redisHelper.get('foo', request_id) === 'bar3'}"

sleep(2)
puts "after 6 second get foo: (should have expired): getFoo == nil : #{redisHelper.get('foo', request_id).nil?}"
