require 'typhoeus'
require "nokogiri"
require 'json'
module Google




  class Request

    def initialize(query)
      query_has_spaces = query.match(/\s/) ? true : false

      if query_has_spaces
        @query = query.gsub ' ', '%20'
      else
        @query = query
      end

    end


    def get


      Typhoeus::Config.verbose = false

      query = "http://api.scraperapi.com/?api_key=#{ENV['SCRAPER_API_KEY']}&url=https://www.google.com/search?q=#{@query}&country_code=us"

      request = Typhoeus::Request.new(
        query
      ).run


      html = request.response_body

      parsed_html = Nokogiri::HTML.parse(html)

      byebug
      data = {
        results: []
      }

      #parsed_data = Nokogiri::HTML(File.open("test.html"))
      elements = parsed_html.xpath("//div[@class='rc']")

      elements.each do |serp|
        title = serp.xpath(".//div[@class='r']/a/h3").text
        description = serp.xpath(".//div[@class='s']/div/span").text
        url = serp.xpath(".//div[@class='r']/a/@href").text
        result_hash = {title: title, description: description, url: url}
        data[:results] << result_hash
      end

      #.encode('utf-8')
      # Google::Request.new("learn how to fish").get

      File.open("test_serp.json","w") do |f|
        f.write(data.to_json)
      end

      byebug



      #  @data_hash = JSON.parse(file)

      first = elements.first

      title = test.xpath(".//a/h3").text

      #elements.each do |element|

        #  link = element.xpath('.//a/@href')[0].value

        #  if !link.include?("https://twitter.com/" + @handle) && !filter_includes_url?(link)
          #  @links << link
          #end
        #end

      #resp = Google::Request.new("learn how to fish").get
    end

    def test_request

      options = {
        :headers => {"User-Agent" => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0'}
      }
      #http_proxyaddr: 'zproxy.lum-superproxy.io',
      #http_proxyport: '22225',
      request = Typhoeus::Request.new(
        @query,
        options
      ).run







      byebug
    end

  end
end
#Typhoeus.get('http://suggestqueries.google.com/complete/search?client=firefox&q=best%20glock')
