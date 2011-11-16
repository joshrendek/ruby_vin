require 'rubygems'
require 'hpricot'
require 'net/http'
require 'net/https'
require 'cgi'

module RubyVin
  USERAGENT = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'

  # rails source
  def self.underscore(camel_cased_word)
    word = camel_cased_word.to_s.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.gsub!(' ', '_')
    word.downcase!
    word
  end

  module Ford
    URL = 'www.fleet.ford.com'
    PATH = '/maintenance/vin_tools/vinResults.asp'
    def self.test(vin)
      @http = Net::HTTP.new(URL, 443)
      @http.use_ssl = true

      # set cookies
      resp, data = @http.get2(PATH, {'User-Agent' => USERAGENT})
      cookie = resp.response['set-cookie'].split('; ')[0]


      headers = {
        'User-Agent' => USERAGENT,
        'Cookie' => cookie,
        'Referer' => 'https://'+URL+PATH
      }

      data = "txtVin=#{vin}&imageField=Submit"
      res, data = @http.post2(PATH, data, headers)
      #print data
      #print res.code

      doc = Hpricot(data)
      hash = {}
      doc.search('#tablegeneral tr').each do |tr|
        row = tr.search('td')
        begin
          k = RubyVin.underscore(row.first.inner_html.to_s.gsub(':', '').strip)
          v = row.last.inner_html.strip.gsub(/&#.{0,}?;/, '') # remove html entity garbage
            hash[k] = v
        rescue =>e ; p e;  end; 

        p "-"*20
      end

      p hash
    end

  end

end

