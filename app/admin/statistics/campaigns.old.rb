# ActiveAdmin.register Campaign, as: 'StatisticsForCampaigns' do
#   actions :all, only: []
#
#
#   menu parent: "Statistics", label: 'Campaigns'
#   scope 'Parents', default: true do |scope|
#     scope.select('campaigns.id as ca_id', 'campaigns.parent_id as ca_parent_id',
#                  'campaigns.payment_model as ca_payment_model',
#                  'campaigns.traffic_cost as ca_traffic_cost')
#         .group('campaigns.id')
#         .reorder('(CASE WHEN campaigns.parent_id is NULL THEN campaigns.parent_id END) ASC,
#         CASE WHEN campaigns.parent_id IS NOT NULL THEN campaigns.id END DESC')
#   end
#   # scope 's2' do |scope|
#   #   scope.select('s2').group('clicks.s2').reorder('s2')
#   # end.group('clicks.campaign_id')
#   # scope 's3' do |scope|
#   #   scope.select('s3').group('clicks.s3').reorder('s3')
#   # end
#   # scope 's4' do |scope|
#   #   scope.select('s4').group('clicks.s4').reorder('s4')
#   # end
#   # scope 's5' do |scope|
#   #   scope.select('s5').group('clicks.s5').reorder('s5')
#   # end
#
#   # index as: :grouped_table, group_by_attribute: :s1 do
#   #   column "Sub" do |row|
#   #     row
#   #   end
#   # end
#   #
#   # index do
#   #   column :s do |row|
#   #     if row.s1
#   #       row.s1
#   #     end
#   #   end
#   #   column 'Clicks', :count
#   #   column 'Hits', :hits
#   #   column 'Leads' do |row|
#   #     conv = Conversion.find_by()
#   #   end
#   # end
#   before_filter :only => [:index] do
#     if params['id_or_parent_id'].blank? and (not params['q'] or params['q']['id_or_parent_id_eq'].blank?)
#       params['q'] = {'id_or_parent_id_eq'=> Campaign.workings.last.id}
#     end
#   end
#
#   filter :id_or_parent_id_eq, as: :select, :collection => Campaign.workings.map { |o| [o.name, o.id] }, :include_blank => false
#   filter :cl_created_at, :as => :date_range
#
#   index :row_class => -> record { 'index_table_working_campaigns' unless record.ca_parent_id } do
#     # scope = params[:scope]
#     # unless scope
#     #   scope = 'All'
#     # end
#     # column scope
#     column 'Campaign' do |row|
#       # if row.ca_parent_id
#       #   span "(#{row.ca_id})-> #{row.ca_parent_id}"
#       #   #link_to "(#{row.id})-> #{row.created_at.strftime('%d.%m.%y')}", admin_campaign_path(row.parent_id)
#       # else
#       #   row.ca_id
#       # end
#       row.ca_id
#     end
#     column 'Model' do |row|
#       span "#{row.ca_payment_model} (#{row.ca_traffic_cost}₽)"
#
#     end
#     column 'Clicks' do |row|
#       span row.cl_clicks
#     end
#     # column :actives
#     # column :hits
#     # column 'Views' do |row|
#     #   if row.parent
#     #     span row.parent.views_count.to_s
#     #   else
#     #     span row.views_count.to_s
#     #   end
#     # end
#     # column 'CTR' do |row|
#     #   span (row.clicks.to_f / row.views_count.to_f).round(2).to_s + '%'
#     # end
#     # column 'EPC' do |row|
#     #   all = row.money_approve.to_f + row.money_wait.to_f
#     #   span (all.to_f / row.clicks.to_f).round(2).to_s + '₽'
#     # end
#     # column 'REPC' do |row|
#     #   span (row.money_approve.to_f / row.clicks.to_f).round(2).to_s + '₽'
#     # end
#     # column 'CEPC' do |row|
#     #   if row.payment_model == 'cpc'
#     #     if row.payment_model == 'cpc'
#     #       span ((row.money_approve.to_f - (row.clicks.to_f * row.traffic_cost.to_f)) /
#     #           row.clicks.to_f).round(2).to_s + '₽'
#     #     elsif row.payment_model == 'cpm'
#     #       span ((row.money_approve.to_f - (row.clicks.to_f * row.traffic_cost.to_f)) /
#     #           row.clicks.to_f).round(2).to_s + '₽'
#     #     end
#     #   else
#     #     span '-'
#     #   end
#     # end
#     # column 'EPM' do |row|
#     #   all = row.money_approve.to_f + row.money_wait.to_f
#     #   span (all.to_f / row.views_count.to_f).round(2).to_s + '₽'
#     # end
#     # column 'REPM' do |row|
#     #   span (row.money_approve.to_f / row.views_count.to_f).round(2).to_s + '₽'
#     # end
#     # column 'CEPM' do |row|
#     #   if row.payment_model == 'cpm'
#     #     if row.payment_model == 'cpc'
#     #       span ((row.money_approve.to_f - ((row.views_count.to_f/1000) * row.traffic_cost.to_f)) /
#     #           row.views_count.to_f).round(2).to_s + '₽'
#     #     elsif row.payment_model == 'cpm'
#     #       span ((row.money_approve.to_f - ((row.views_count.to_f/1000) * row.traffic_cost.to_f)) /
#     #           row.views_count.to_f).round(2).to_s + '₽'
#     #     end
#     #   else
#     #     span '-'
#     #   end
#     # end
#     # column 'CR' do |row|
#     #   all = row.wait + row.approve + row.decline
#     #   if all > 0
#     #     span (row.approve.to_f / all.to_f * 100).round(2).to_s + '%'
#     #   else
#     #     span 0.to_s + '%'
#     #   end
#     # end
#     # column 'Leads (W/A/D)' do |row|
#     #   span row.wait.to_s + ' /', style: 'color: blue'
#     #   span row.approve.to_s + ' /', style: 'color: green'
#     #   span row.decline.to_s, style: 'color: red'
#     # end
#     # column 'Money (W/A/D)' do |row|
#     #   span row.money_wait.to_s + ' /', style: 'color: blue'
#     #   span row.money_approve.to_s + ' /', style: 'color: green'
#     #   span row.money_decline.to_s, style: 'color: red'
#     #   span '₽'
#     # end
#     # table_for :histories do |r|
#     #   columns do
#     #     column do |row|
#     #       span r
#     #     end
#     #   end
#     # end
#   end
#
#   controller do
#     def scoped_collection
#       #Campaign.left_outer_joins(:clicks, :conversions)
#       Campaign.joins('LEFT JOIN clicks as cl ON (campaigns.id = cl.campaign_id AND cl.history_id IS NULL) OR campaigns.id = cl.history_id')
#           .left_outer_joins(:conversions).select(
#               'sum(case when cl.amount > 0 then 1 else 0 end) cl_clicks',
#               'sum(case when cl.activity::int > 0 then 1 else 0 end) cl_actives',
#               'sum(case when cl.amount > 0 then cl.amount else 0 end) cl_hits',
#               'sum(case when conversions.status = 0 then 1 else 0 end) wait',
#               'sum(case when conversions.status = 1 then 1 else 0 end) approve',
#               'sum(case when conversions.status = 2 then 1 else 0 end) decline',
#               'sum(case when conversions.status = 0 then conversions.ext_payout::int else 0 end) money_wait',
#               'sum(case when conversions.status = 1 then conversions.ext_payout::int else 0 end) money_approve',
#               'sum(case when conversions.status = 2 then conversions.ext_payout::int else 0 end) money_decline'
#           )
#     end
#   end
# end
