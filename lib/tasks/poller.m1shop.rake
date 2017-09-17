require 'net/http'
require 'uri'
namespace :poller do
  task m1shop: :environment do
    query_string = ''
    i = 0
    Conversion.where('status = 0').all.each do |conversion|
      if conversion.campaign.integration == 'm1shop'
        if i == 0
          query_string += '&id=' + conversion.ext_id.to_s
        else
          query_string += ',' + conversion.ext_id.to_s
        end
        i += 1
      end
    end
    if query_string.size > 0
      query_string = 'https://m1-shop.ru/get_order_status/?ref=80853&api_key=b76aa5c68ce484d021cdb6ee314bccda' + query_string
      response = Net::HTTP.get(URI.parse(query_string))
      if response
        res_json = JSON.parse(response)
        p res_json
        leads = res_json['result']
        if leads.size > 0
          leads.each do |lead|
            status = 0
            if lead['status'] != 0
              case lead['status'].to_i
                when 1
                  status = 1
                when 2
                  status = 2
                when 3
                  status = 1
                when 4
                  status = 2
              end
              if lead['trash'].to_i == 1
                status = 2
              end
              Conversion.update(lead['extenal_id'], {
                  :status => status,
                  :ext_comment => "#{lead['comment']} #{lead['callcenter_comment']}"
              })
              p "Conversion #{lead['id']} updated status to #{status}"
            end
          end
        end
      end
    end
  end
end
