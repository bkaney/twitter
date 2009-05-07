module Twitter

  # Twitter::Trend.new.current.fetch
  class Trend
    include HTTParty
    include Enumerable

    CURRENT = 0x001
    DAILY   = 0x010
    WEEKLY  = 0x100
    
    attr_reader :result, :query

    def initialize
      @mode = nil
      @query = {}
      @fetch = nil
    end

    def weekly
      raise TwitterError, "Already specified daily or current!" if @mode
      @mode = WEEKLY
      self
    end

    def daily
      raise TwitterError, "Already specified weekly or current!" if @mode
      @mode = DAILY
      self
    end

    def current
      raise TwitterError, "Already specified daily or weekly!" if @mode
      @mode = CURRENT
      self
    end

    def exclude_hashtags
      @query[:exclude] = 'hashtags'
      self
    end

    def starting(date)
      @query[:date] = date.strftime('%Y-%M-%d')
      self
    end

    def fetch(force=false)
      if @fetch.nil? || force
        url = case @mode
        when CURRENT
          'http://search.twitter.com/trends/current.json'
        when DAILY
          'http://search.twitter.com/trends/daily.json'
        when WEEKLY
          'http://search.twitter.com/trends/weekly.json'
        else
          'http://search.twitter.com/trends.json'
        end
        opts = { :format => :json, :query => {} }
        opts[:query][:date] = @query[:date] if @query[:date]
        opts[:query][:exclude] = @query[:exclude] if @query[:exclude]
        response = self.class.get(url, opts)
        @fetch = Mash.new(response)
      end

      @fetch
    end

    def each
      fetch()['trends'].each { |r| yield r }
    end
  end

end
