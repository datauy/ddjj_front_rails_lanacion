require 'net/http'
require 'json'
module ApplicationHelper
  def convert_currency amount, from, to
    if from == to
      amount
    else
      @key = from+'_'+to
      @resp = Rails.cache.read(@key)
      if @resp.nil?
        Rails.logger.info { "\n\n"+"Primer intento: "+@key+"\n" }
        url = 'http://data.fixer.io/api/latest?symbols=COP,ARS,USD,GTQ&access_key=56b265aabcaa3e860ab378ec12e278e5'
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        @res = http.get(uri.request_uri)
        if @res.is_a?(Net::HTTPSuccess)
          Rails.logger.info { "\nPrimer intento SUCCESS\n" }
          res_obj = JSON.parse(@res.body)
          res_obj_s = OpenStruct.new(res_obj)
          rates = OpenStruct.new(res_obj_s.rates)
          #Rails.logger.info res_obj_s.rates.inspect
          conversion = {
            ARS: rates.ARS/rates.USD,
            COP: rates.COP/rates.USD,
            GTQ: rates.GTQ/rates.USD
          }
          Rails.logger.info conversion.inspect
          #ARS
          Rails.cache.write('ARS_USD', conversion[:ARS], :expires_in => 30.minutes)
          Rails.cache.write("ARS_USD_ext", conversion[:ARS])
          Rails.cache.write("ARS_USD_time", Time.now)
          #COP
          Rails.cache.write('COP_USD', conversion[:COP], :expires_in => 30.minutes)
          Rails.cache.write("COP_USD_ext", conversion[:COP])
          Rails.cache.write("COP_USD_time", Time.now)
          #GTQ
          Rails.cache.write('GTQ_USD', conversion[:GTQ], :expires_in => 30.minutes)
          Rails.cache.write("GTQ_USD_ext", conversion[:GTQ])
          Rails.cache.write("GTQ_USD_time", Time.now)

          @conv_key = ':' + from;
          return conversion[from.to_sym]
        else
          Rails.logger.info { "\n\n"+"Segundo intento:\n\n" }
          url = 'https://free.currconv.com/api/v7/convert?compact=ultra&apiKey=9441f9c1db78d9d32fea&q='+@key
          uri = URI(url)
          #res = Net::HTTP.new(uri.host, uri.port)#, "compact" => "ultra", "apiKey" => "9441f9c1db78d9d32fea","q" => @key)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          #request_header = { 'Content-Type': 'application/json' }
          @res = http.get(uri.request_uri)
          if @res.is_a?(Net::HTTPSuccess)
            res_obj = JSON.parse(@res.body)
            Rails.cache.write(@key, 1/res_obj[@key], :expires_in => 30.minutes)
            Rails.cache.write(@key+"_ext", 1/res_obj[@key])
            Rails.cache.write(@key+"_time", Time.now)
            Rails.logger.info { "\n\nCache actualizado\n" }
            return 1/res_obj[@key]
          else
            @last_ext = Rails.cache.read(@key+'_ext')
            Rails.cache.write(@key, @last_ext, :expires_in => 30.minutes)
          end
        end
      else
        return @resp
      end
    end
  end
end
