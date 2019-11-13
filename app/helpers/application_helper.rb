require 'net/http'
require 'json'
module ApplicationHelper
  def convert_currency amount, from, to
    if from == to
      amount
    else
      @key = from+'_'+to
      Rails.cache.fetch(@key, :expires_in => CANT_DJ_Y_ULT_ACT) do
        url = 'https://free.currconv.com/api/v7/convert?compact=ultra&apiKey=9441f9c1db78d9d32fea&q='+@key
        Rails.logger.info { "\n\nHELPER URL:"+url+"\n" }
        uri = URI(url)
        #res = Net::HTTP.new(uri.host, uri.port)#, "compact" => "ultra", "apiKey" => "9441f9c1db78d9d32fea","q" => @key)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        #request_header = { 'Content-Type': 'application/json' }
        @res = http.get(uri.request_uri)
        res_obj = JSON.parse(@res.body)
        res_obj[@key]
      end
    end
  end
end
