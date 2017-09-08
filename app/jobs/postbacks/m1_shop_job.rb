require 'net/http'
require 'uri'

class Postbacks::M1ShopJob < ApplicationJob
  queue_as :default_priority
  def perform(*args)
    conversion = args[0][:conversion]
    params = {
        :ref => 80853,
        :api_key => 'b76aa5c68ce484d021cdb6ee314bccda',
        :product_id => args[0][:offer_id],
        :name => conversion.client_name,
        :phone => conversion.client_phone,
        :ip => conversion.visitor&.ip.to_s,
    }
    response = Net::HTTP.post_form(URI.parse('http://m1-shop.ru/send_order/'), params)
    if response
      res_json = JSON.parse(response.body)
      id = res_json['id'].to_s
      if id.strip.size > 0
        conversion.ext_id = id
        conversion.save
      end
    end
  end
end