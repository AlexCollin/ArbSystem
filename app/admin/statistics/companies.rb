ActiveAdmin.register Click, as: 'StatisticsForCampaigns' do
  actions :all, only: []


  menu parent: "Statistics", label: 'Campaigns'
  scope 'Parents', default: true do |scope|
    scope.select('clicks.campaign_id, clicks.history_id')
        .group('clicks.history_id').group('clicks.campaign_id')
        .reorder('clicks.campaign_id DESC, clicks.history_id DESC')
  end
  # scope 's2' do |scope|
  #   scope.select('s2').group('clicks.s2').reorder('s2')
  # end
  # scope 's3' do |scope|
  #   scope.select('s3').group('clicks.s3').reorder('s3')
  # end
  # scope 's4' do |scope|
  #   scope.select('s4').group('clicks.s4').reorder('s4')
  # end
  # scope 's5' do |scope|
  #   scope.select('s5').group('clicks.s5').reorder('s5')
  # end

  # index as: :grouped_table, group_by_attribute: :s1 do
  #   column "Sub" do |row|
  #     row
  #   end
  # end
  #
  # index do
  #   column :s do |row|
  #     if row.s1
  #       row.s1
  #     end
  #   end
  #   column 'Clicks', :count
  #   column 'Hits', :hits
  #   column 'Leads' do |row|
  #     conv = Conversion.find_by()
  #   end
  # end
  before_filter :only => [:index] do
    if params['campaign_id'].blank? and (not params['q'] or params['q']['campaign_id_eq'].blank?)
      params['q'] = {'campaign_id_eq' => Campaign.workings.last.id}
    end
  end

  filter :campaign, :collection => Campaign.workings.map { |o| [o.name, o.id] }, :include_blank => false
  filter :created_at

  index :row_class => -> record { 'index_table_working_campaigns' unless record.history_id } do
    # scope = params[:scope]
    # unless scope
    #   scope = 'All'
    # end
    # column scope
    column :campaign do |row|
      if row.campaign
        if row.history_id
          link_to "(#{row.history_id})-> #{row.campaign.created_at.strftime('%d.%m.%y')}", admin_campaign_path(row.history_id)
        else
          link_to row.campaign, admin_campaign_path(row.campaign_id)
        end
      end
    end
    column 'Model' do |row|
      if row.campaign
        span "#{row.campaign.payment_model} (#{row.campaign.traffic_cost}₽)"
      else
        span '-'
      end
    end
    column :clicks
    column :actives
    column :hits
    column 'Views' do |row|
      if row.campaign
        if row.history_id
          span row.history.views_count.to_s
        else
          span row.campaign.views_count.to_s
        end
      else
        span '-'
      end
    end
    column 'CTR' do |row|
      if row.campaign
        span (row.clicks.to_f / row.campaign.views_count.to_f).round(2).to_s + '%'
      else
        span '-'
      end
    end
    column 'EPC' do |row|
      all = row.money_approve.to_f + row.money_wait.to_f
      span (all.to_f / row.clicks.to_f).round(2).to_s + '₽'
    end
    column 'REPC' do |row|
      span (row.money_approve.to_f / row.clicks.to_f).round(2).to_s + '₽'
    end
    column 'CEPC' do |row|
      if row.campaign and row.campaign.payment_model == 'cpc'
        if row.campaign.payment_model == 'cpc'
          span ((row.money_approve.to_f - (row.clicks.to_f * row.campaign.traffic_cost.to_f)) /
              row.clicks.to_f).round(2).to_s + '₽'
        elsif row.campaign.payment_model == 'cpm'
          span ((row.money_approve.to_f - (row.clicks.to_f * row.campaign.traffic_cost.to_f)) /
              row.clicks.to_f).round(2).to_s + '₽'
        end
      else
        span '-'
      end
    end
    column 'EPM' do |row|
      all = row.money_approve.to_f + row.money_wait.to_f
      span (all.to_f / row.campaign.views_count.to_f).round(2).to_s + '₽'
    end
    column 'REPM' do |row|
      span (row.money_approve.to_f / row.campaign.views_count.to_f).round(2).to_s + '₽'
    end
    column 'CEPM' do |row|
      if row.campaign and row.campaign.payment_model == 'cpm'
        if row.campaign.payment_model == 'cpc'
          span ((row.money_approve.to_f - ((row.campaign.views_count.to_f/1000) * row.campaign.traffic_cost.to_f)) /
              row.campaign.views_count.to_f).round(2).to_s + '₽'
        elsif row.campaign.payment_model == 'cpm'
          span ((row.money_approve.to_f - ((row.campaign.views_count.to_f/1000) * row.campaign.traffic_cost.to_f)) /
              row.campaign.views_count.to_f).round(2).to_s + '₽'
        end
      else
        span '-'
      end
    end
    column 'CR' do |row|
      all = row.wait + row.approve + row.decline
      if all > 0
        span (row.approve.to_f / all.to_f * 100).round(2).to_s + '%'
      else
        span 0.to_s + '%'
      end
    end
    column 'Leads (W/A/D)' do |row|
      span row.wait.to_s + ' /', style: 'color: blue'
      span row.approve.to_s + ' /', style: 'color: green'
      span row.decline.to_s, style: 'color: red'
    end
    column 'Money (W/A/D)' do |row|
      span row.money_wait.to_s + ' /', style: 'color: blue'
      span row.money_approve.to_s + ' /', style: 'color: green'
      span row.money_decline.to_s, style: 'color: red'
      span '₽'
    end
    table_for :histories do |r|
      columns do
        column do |row|
          span r
        end
      end
    end
  end

  controller do
    def scoped_collection
      Click.left_outer_joins(:conversions)
          .select(
              'sum(case when clicks.amount > 0 then 1 else 0 end) clicks',
              'sum(case when clicks.activity::int > 0 then 1 else 0 end) actives',
              'sum(case when clicks.amount > 0 then clicks.amount else 0 end) hits',
              'sum(case when conversions.status = 0 then 1 else 0 end) wait',
              'sum(case when conversions.status = 1 then 1 else 0 end) approve',
              'sum(case when conversions.status = 2 then 1 else 0 end) decline',
              'sum(case when conversions.status = 0 then conversions.ext_payout::int else 0 end) money_wait',
              'sum(case when conversions.status = 1 then conversions.ext_payout::int else 0 end) money_approve',
              'sum(case when conversions.status = 2 then conversions.ext_payout::int else 0 end) money_decline'
          )
    end
  end
end
