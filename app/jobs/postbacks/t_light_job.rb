require 'net/http'
require 'uri'

class Postbacks::TLightJob < ApplicationJob
  queue_as :default_priority
  def perform(*args)
    conversion = args[0][:conversion]
    params = {
        :key => 'dPimhuccBmkrCb6zrz3YVy3zixA1BOlKrmtY5',
        :offer_id => args[0][:offer_id],
        :id => conversion.id,
        :name => conversion.client_name,
        :phone => conversion.client_phone,
        :country => 'RU',
        :landing_currency => 'RUB',
        :landing_cost => conversion.extra['Ценник'].to_i,
        :ip_address => conversion.visitor&.ip.to_s,
        :comments => conversion.extra['Артикул'].to_s + ' ' + conversion.extra['Категория'].to_s
    }
    response = Net::HTTP.post_form(URI.parse('http://cpa.tlight.biz/api/lead/send'), params)
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