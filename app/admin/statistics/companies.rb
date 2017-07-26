ActiveAdmin.register Click, as: 'StatisticsForCampaigns' do
  includes :campaign
  actions :all, only: []


  menu parent: "Statistics", label: 'Campaigns'
  scope 'Coefficients', default: true do |scope|
    scope.select('clicks.campaign_id, clicks.working_campaign_id')
        .group('clicks.campaign_id').group('clicks.working_campaign_id')
        .reorder('clicks.campaign_id ASC, clicks.working_campaign_id ASC')
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
    if params['working_campaign_id'].blank? and (not params['q'] or params['q']['working_campaign_id_eq'].blank?)
      params['q'] = {'working_campaign_id_eq' => Campaign.where('campaigns.parent_id IS NULL')&.last&.id || ''}
    end
  end

  filter :working_campaign, :collection => Campaign.where('campaigns.parent_id IS NULL').map { |o| [o.name, o.id] }, :include_blank => false
  filter :created_at

  index :row_class => -> record { 'index_table_working_campaigns' if record.working_campaign_id == record.campaign_id } do
    # scope = params[:scope]
    # unless scope
    #   scope = 'All'
    # end
    # column scope
    column :campaign do |row|
      unless row.is_working_campaign
        link_to "(#{row.campaign_id})-> #{row.campaign.created_at.strftime('%d.%m.%y')}", admin_campaign_path(row.campaign_id)
      else
        link_to row.campaign, admin_campaign_path(row.campaign_id)
      end
    end
    column 'Model' do |row|
      span "#{row.campaign.payment_model} (#{row.campaign.traffic_cost}₽)"

    end
    column :clicks
    column :actives
    column :hits
    column 'Views' do |row|
      if row.campaign
        span row.campaign.views.to_s
      else
        span '-'
      end
    end
    column 'CTR' do |row|
      if row.clicks > 0 and row.campaign.views > 0
        span (row.clicks.to_f / row.campaign.views.to_f).round(3).to_s + '%'
      else
        span '-'
      end

    end
    column 'EPC' do |row|
      if row.clicks > 0
        all = row.money_approve.to_f + row.money_wait.to_f
        span (all.to_f / row.clicks.to_f).round(2).to_s + '₽'
      else
        span '-'
      end
    end
    column 'REPC' do |row|
      if row.clicks > 0
        span (row.money_approve.to_f / row.clicks.to_f).round(2).to_s + '₽'
      else
        span '-'
      end
    end
    column 'CEPC' do |row|
      if row.clicks > 0 and row.campaign and row.campaign.payment_model == 'cpc'
        span ((row.money_approve.to_f - (row.clicks.to_f * row.campaign.traffic_cost.to_f)) /
            row.clicks.to_f).round(2).to_s + '₽'
      else
        span '-'
      end
    end
    column 'EPM' do |row|
      if row.campaign.views.to_i > 0
        all = row.money_approve.to_f + row.money_wait.to_f
        span (all.to_f / row.campaign.views.to_f).round(2).to_s + '₽'
      else
        span '-'
      end
    end
    column 'REPM' do |row|
      if row.campaign.views > 0
        span (row.money_approve.to_f / row.campaign.views.to_f).round(2).to_s + '₽'
      else
        span '-'
      end
    end
    column 'CEPM' do |row|
      if row.campaign and row.campaign.views > 0 and row.campaign.payment_model == 'cpm'
        cost = (row.campaign.views.to_f/1000).to_f * row.campaign.traffic_cost.to_f
        span ((row.money_approve.to_f - cost).round(2)).to_s + '₽'
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
  end

  controller do
    def scoped_collection
      Click.left_outer_joins(:conversions, :campaign)
          .select(
              'sum(case when clicks.amount > 0 then 1 else 0 end) clicks',
              'sum(case when clicks.activity::int > 0 then 1 else 0 end) actives',
              'sum(case when clicks.amount > 0 then clicks.amount else 0 end) hits',
              'sum(case when conversions.status = 0 then 1 else 0 end) wait',
              'sum(case when conversions.status = 1 then 1 else 0 end) approve',
              'sum(case when conversions.status = 2 then 1 else 0 end) decline',
              'sum(case when conversions.status = 0 then campaigns.lead_cost::int else 0 end) money_wait',
              'sum(case when conversions.status = 1 then campaigns.lead_cost::int else 0 end) money_approve',
              'sum(case when conversions.status = 2 then campaigns.lead_cost::int else 0 end) money_decline'
          )
    end
  end
end
