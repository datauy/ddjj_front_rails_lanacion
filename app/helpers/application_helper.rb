require 'net/http'
module ApplicationHelper
  def convert_currency amount, from, to
    Rails.logger.info { "\n\nHELPER:\n"+from }
    #uri = URI('https://api.iban.com/clients/api/currency/convert/')
    #uri = URI(request.base_url+'/currency-exchange.json?from='+from+'&amount='+amount.to_s)
    #res = Net::HTTP.get_response(uri)#, "format" => "json", "from" => from,"to" => to, "amount" => amount)
    #Rails.logger.info { "\n\nHELPER RES:\n" }
    #Rails.logger.info res.inspect
    #res.body
    country_currency = {
      '$' => [29.27, 17.227, 15.359, 9.617, 8.448, 5.704],
      'COP' => [2977, 3145, 3145, 3145, 3145, 3145],
      'Q' => [7.54, 7.54, 7.54, 7.54, 7.54, 5.704],
      'EUR' => [0.8495, 0.8495, 0.8495, 0.8495, 0.8495, 0.8495]
    }
    # se considera 2018 como año 0
    #https://es.investing.com/currencies/usd-cop-historical-data
    @value = (amount.to_f/country_currency[from][0]).round(2)
  end
end
