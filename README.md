# RedisTestProgram

*Basic Intro (My blog):*
https://notafraidofwong.blogspot.com/2019/01/redis-quick-start-to-redis.html

## Quick Start (For Windows)
1. Run redis-server-<version num>.exe  

2. Install JRuby (or Ruby) with Bundler (if not already)
	 - to install bundler, run 'gem install bundler'

3. Run 'bundle install'

4. rspec spec/\<any test file\>.rb

### Using CLI

5. Run redis-cli-<version num>.exe

6. Run basic redis commands to the server.

## Updating Redis

1. Download a zip folder (Redis-*.zip) from https://github.com/MicrosoftArchive/redis/release

2. Unzip.

3. Run redis-server.exe

# What is RedisDeleteHasCronJob?

Although there is a EXPIRE method for normal key-value in redis, there is no such method for the value of a hash (in Redis). Therefore, an alternative method is to create a cron job, iterate the hash values and delete them manually. 

## Advantages

 - Can log all the deletions.
 
 - More control over delete condition.