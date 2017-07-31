require 'net/http'
require 'uri'
namespace :poller do
  task tlight: :environment do
    query_string = ''
    Conversion.where('status = 0').all.each do |conversion|
      query_string += '&id2=' + conversion.id.to_s
    end
    if query_string.size > 0
      query_string = 'http://cpa.tlight.biz/api/lead/feed?key=dPimhuccBmkrCb6zrz3YVy3zixA1BOlKrmtY5' + query_string
      response = Net::HTTP.get(URI.parse(query_string))
      if response
        res_json = JSON.parse(response)
        leads = res_json['leads']
        if leads.size > 0
          leads.each do |lead|
            if lead['status_code'] != 0
              status = 0
              if lead['status_code'] == 10
                status = 1
              elsif lead['status_code'] == -10
                status = 2
              end
              Conversion.update(lead['id2'], {
                  :status => status,
                  :ext_comment => lead['comment'],
                  :ext_payout => lead['fee'],
                  :payout => lead['fee'].to_f
              })
              p "Conversion #{lead['id2']} updated status to #{status}"
            end
          end
        end
      end
    end
  end
end
