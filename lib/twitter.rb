require 'forwardable'
require 'rubygems'

gem 'oauth', '0.3.2'
require 'oauth'

gem 'mash', '0.0.3'
require 'mash'

gem 'httparty', '0.4.3'
require 'httparty'

module Twitter
  class TwitterError < StandardError
    attr_reader :data
    
    def initialize(data)
      @data = data
      super
    end
  end
  
  class RateLimitExceeded < TwitterError; end
  class Unauthorized      < TwitterError; end
  class General           < TwitterError; end
  
  class Unavailable   < StandardError; end
  class InformTwitter < StandardError; end
  class NotFound      < StandardError; end
  
  
  def self.firehose
    response = HTTParty.get('http://twitter.com/statuses/public_timeline.json', :format => :json)
    response.map { |tweet| Mash.new(tweet) }
  end
  
  def self.user(id)
    response = HTTParty.get("http://twitter.com/users/show/#{id}.json", :format => :json)
    Mash.new(response)
  end
  
  def self.status(id)
    response = HTTParty.get("http://twitter.com/statuses/show/#{id}.json", :format => :json)
    Mash.new(response)
  end
  
  def self.friend_ids(id)
    HTTParty.get("http://twitter.com/friends/ids/#{id}.json", :format => :json)
  end
  
  def self.follower_ids(id)
    HTTParty.get("http://twitter.com/followers/ids/#{id}.json", :format => :json)
  end
end

directory = File.dirname(__FILE__)
$:.unshift(directory) unless $:.include?(directory)

require 'twitter/oauth'
require 'twitter/httpauth'
require 'twitter/request'
require 'twitter/base'
require 'twitter/search'
require 'twitter/trend'
