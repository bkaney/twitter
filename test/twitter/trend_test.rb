require File.dirname(__FILE__) + '/../test_helper'

class SearchTest < Test::Unit::TestCase
  context "trends" do
    setup do
      @trend = Twitter::Trend.new
      stub_get('http://search.twitter.com:80/trends.json', 'trends.json')
      stub_get('http://search.twitter.com:80/trends/current.json', 'trends.current.json')
      stub_get('http://search.twitter.com:80/trends/daily.json', 'trends.daily.json')
      stub_get('http://search.twitter.com:80/trends/weekly.json', 'trends.weekly.json')
    end
    
    should "be able to fetch" do
      @trend.fetch.should_not be_nil
    end

    should "be able to specify current" do
      @trend.current.fetch.should_not be_nil
    end

    should "be able to specify daily" do
      @trend.daily.fetch.should_not be_nil
    end
    
    should "be able to specify weekly" do
      @trend.weekly.fetch.should_not be_nil
    end

    should "be able to specify exclude_hashtags" do
      @trend.class.expects(:get).with('http://search.twitter.com/trends.json', :query => { :exclude => 'hashtags' }, :format => :json).returns({'foo' => 'bar'})
      @trend.exclude_hashtags.fetch
    end

    should "be able to specify starting" do
      nowish = Time.now
      @trend.class.expects(:get).with('http://search.twitter.com/trends.json', :query => { :date => nowish.strftime('%Y-%M-%d') }, :format => :json).returns({'foo' => 'bar'})
      @trend.starting(nowish).fetch
    end

  end
end
