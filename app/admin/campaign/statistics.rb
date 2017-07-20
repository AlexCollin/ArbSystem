ActiveAdmin.register Campaign, as: 'CampaignsGeneralStatistics' do
  includes :history_clicks, :clicks, :conversions
  actions :all, only: []


  menu parent: "Campaigns", label: 'General Statistics'
  scope 'Coefficients', default: true do |scope|
    scope.workings.reorder('(CASE WHEN campaigns.parent_id is NULL THEN campaigns.parent_id END) ASC,
        CASE WHEN campaigns.parent_id IS NOT NULL THEN campaigns.id END DESC')
  end
  # scope 's2' do |scope|
  #   scope.select('s2').group('clicks.s2').reorder('s2')
  # end.group('clicks.campaign_id')
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
    if params['id_or_parent_id'].blank? and (not params['q'] or params['q']['id_or_parent_id_eq'].blank?)
      params['q'] = {'id_or_parent_id_eq' => Campaign.workings.last.id}
    end
  end

  filter :id_or_parent_id_eq, as: :select, :collection => Campaign.workings.map { |o| [o.name, o.id] }, :include_blank => false

  index do
    # scope = params[:scope]
    # unless scope
    #   scope = 'All'
    # end
    # column scope
    column 'Common' do |row|
      clicks = row.clicks.count
      views_count = row.get_views_count_from_history(true)
      approve = row.conversions.approved.count
      wait = row.conversions.waiting.count
      decline = row.conversions.approved.count
      money_approve = (approve * row.lead_cost).to_i
      money_wait = (wait * row.lead_cost).to_i
      money_decline = (decline * row.lead_cost).to_i
      attributes_table_for row do
        row 'Name' do
          link_to row.name, admin_campaign_path(row.id)
        end
        row 'Clicks' do
          clicks
        end
        row 'Actives' do
          row.clicks.count('activity')
        end
        row 'Hits' do
          row.clicks.sum('amount')
        end
        row 'Views' do
          views_count
        end
        row 'CTR' do
          span (clicks.to_f / views_count.to_f).round(2).to_s + '%'
        end
        row 'EPC' do
          all = money_approve.to_f + money_wait.to_f
          span (all.to_f / clicks.to_f).round(2).to_s + '₽'
        end
        row 'REPC' do
          span (money_approve.to_f / clicks.to_f).round(2).to_s + '₽'
        end
        row 'CEPC' do
          if row.payment_model == 'cpc'
            span ((money_approve.to_f - (clicks.to_f * row.traffic_cost.to_f)) /
                clicks.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        row 'EPM' do
          all = money_approve.to_f + money_wait.to_f
          span (all.to_f / views_count.to_f).round(2).to_s + '₽'
        end
        row 'REPM' do
          span (money_approve.to_f / views_count.to_f).round(2).to_s + '₽'
        end
        row 'CEPM' do
          if row.payment_model == 'cpm'
            span ((money_approve.to_f - ((views_count.to_f/1000) * row.traffic_cost.to_f)) /
                views_count.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        row 'CR' do |row|
          all = wait + approve + decline
          if all > 0
            span (approve.to_f / all.to_f * 100).round(2).to_s + '%'
          else
            span 0.to_s + '%'
          end
        end
        row 'Leads (W/A/D)' do |row|
          span wait.to_s + ' /', style: 'color: blue'
          span approve.to_s + ' /', style: 'color: green'
          span decline.to_s, style: 'color: red'
        end
        row 'Money (W/A/D)' do |row|
          span money_wait.to_s + ' /', style: 'color: blue'
          span money_approve.to_s + ' /', style: 'color: green'
          span money_decline.to_s, style: 'color: red'
          span '₽'
        end
      end
      # if row.parent_id
      #   link_to "(#{row.id})-> #{row.created_at.strftime('%d.%m.%y')}", admin_campaign_path(row.parent_id)
      # else
      #   row
      # end
    end
    column 'Splited Campaigns' do |campaign|
      childs = Campaign.joins('LEFT JOIN clicks as cl ON (campaigns.id = cl.campaign_id AND cl.history_id IS NULL) OR
                     campaigns.id = cl.history_id')
                   .left_outer_joins(:conversions).select(
          'campaigns.id, campaigns.name, campaigns.parent_id, campaigns.created_at',
          'campaigns.payment_model, campaigns.traffic_cost, campaigns.views_count',
          'sum(case when cl.amount > 0 then 1 else 0 end) clicks_count',
          'sum(case when cl.activity::int > 0 then 1 else 0 end) actives_count',
          'sum(case when cl.amount > 0 then cl.amount else 0 end) hits_count',
          'sum(case when conversions.status = 0 then 1 else 0 end) conversions_wait',
          'sum(case when conversions.status = 1 then 1 else 0 end) conversions_approve',
          'sum(case when conversions.status = 2 then 1 else 0 end) conversions_decline',
          'sum(case when conversions.status = 0 then conversions.ext_payout::int else 0 end) conversions_money_wait',
          'sum(case when conversions.status = 1 then conversions.ext_payout::int else 0 end) conversions_money_approve',
          'sum(case when conversions.status = 2 then conversions.ext_payout::int else 0 end) conversions_money_decline'
      ).where("campaigns.id = #{campaign.id} OR campaigns.parent_id = #{campaign.id}")
                   .group('campaigns.parent_id').group('campaigns.id')
                   .reorder('(CASE WHEN campaigns.parent_id is NULL THEN campaigns.parent_id END) ASC,
        CASE WHEN campaigns.parent_id IS NOT NULL THEN campaigns.id END DESC')
      table_for childs, :row_class => -> record { 'index_table_working_campaigns' unless record.parent_id } do
        column 'Campaign' do |row|
          if row.parent_id
            link_to "(#{row.id})-> #{row.created_at.strftime('%d.%m.%y')}", admin_campaign_path(row.parent_id)
          else
            link_to 'Parent', admin_campaign_path(row.id)
          end
        end
        column 'Model' do |row|
          span "#{row.payment_model} (#{row.traffic_cost}₽)"
        end
        column 'Clicks' do |row|
          span row.clicks_count
        end
        column 'Actives' do |row|
          span row.actives_count
        end
        column 'Hits' do |row|
          span row.hits_count
        end
        column 'Views' do |row|
          span row.views_count.to_s
        end
        column 'CTR' do |row|
          if row.views_count > 0 and row.clicks_count > 0
            span (row.clicks_count.to_f / row.views_count.to_f).round(2).to_s + '%'
          else
            span '-'
          end
        end
        column 'EPC' do |row|
          if row.views_count > 0 and row.clicks_count > 0
            all = row.conversions_money_approve.to_f + row.conversions_money_wait.to_f
            span (all.to_f / row.clicks_count.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        column 'REPC' do |row|
          if row.views_count > 0 and row.clicks_count > 0
            span (row.conversions_money_approve.to_f / row.clicks_count.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        column 'CEPC' do |row|
          if row.views_count > 0 and row.payment_model == 'cpc' and row.clicks_count > 0
            span ((row.conversions_money_approve.to_f - (row.clicks_count.to_f * row.traffic_cost.to_f)) /
                row.clicks_count.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        column 'EPM' do |row|
          if row.views_count > 0
            all = row.conversions_money_approve.to_f + row.conversions_money_wait.to_f
            span (all.to_f / row.views_count.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        column 'REPM' do |row|
          if row.views_count > 0
            span (row.conversions_money_approve.to_f / row.views_count.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        column 'CEPM' do |row|
          if row.views_count > 0 and row.payment_model == 'cpm'
            span ((row.conversions_money_approve.to_f - ((row.views_count.to_f/1000) * row.traffic_cost.to_f)) /
                row.views_count.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        column 'CR' do |row|
          all = row.conversions_wait + row.conversions_approve + row.conversions_decline
          if all > 0
            span (row.conversions_approve.to_f / all.to_f * 100).round(2).to_s + '%'
          else
            span 0.to_s + '%'
          end
        end
        column 'Leads (W/A/D)' do |row|
          span row.conversions_wait.to_s + ' /', style: 'color: blue'
          span row.conversions_approve.to_s + ' /', style: 'color: green'
          span row.conversions_decline.to_s, style: 'color: red'
        end
        column 'Money (W/A/D)' do |row|
          span row.conversions_money_wait.to_s + ' /', style: 'color: blue'
          span row.conversions_money_approve.to_s + ' /', style: 'color: green'
          span row.conversions_money_decline.to_s, style: 'color: red'
          span '₽'
        end
      end
    end
    # column 'Model' do |row|
    #   span "#{row.payment_model} (#{row.traffic_cost}₽)"
    # end
    # column 'Clicks' do |row|
    #   if row.parent_id
    #     span row.history_clicks.count
    #   else
    #     span row.clicks.where('history_id IS NULL').count
    #   end
    # end
    # column 'Actives' do |row|
    #   span row.clicks.where('activity IS NOT NULL').count
    # end
    # column 'Hits' do |row|
    #   if row.parent_id
    #     span row.history_clicks.sum(:amount)
    #   else
    #     span row.clicks.where('history_id IS NULL').sum(:amount)
    #   end
    # end
    # column 'Views' do |row|
    #   if row.parent_id
    #     span row.views_count.to_s
    #   else
    #     if row.parent_id
    #       span "#{row.views_count.to_s} (#{row.get_views_count_from_history(true)})"
    #     end
    #   end
    # end
    # column 'CTR' do |row|
    #   if row.parent_id
    #     span (row.history_clicks.count.to_f / row.views_count.to_f).round(2).to_s + '%'
    #   else
    #     span (row.clicks.count.to_f / row.views_count.to_f).round(2).to_s + '%'
    #   end
    # end
    # column 'EPC' do |row|
    #   all = row.money_approve.to_f + row.money_wait.to_f
    #   span (all.to_f / row.clicks.count.to_f).round(2).to_s + '₽'
    # end
    # column 'REPC' do |row|
    #   span (row.money_approve.to_f / row.clicks.to_f).round(2).to_s + '₽'
    # end
    # column 'CEPC' do |row|
    #   if row.payment_model == 'cpc'
    #     if row.payment_model == 'cpc'
    #       span ((row.money_approve.to_f - (row.clicks.to_f * row.traffic_cost.to_f)) /
    #           row.clicks.to_f).round(2).to_s + '₽'
    #     elsif row.payment_model == 'cpm'
    #       span ((row.money_approve.to_f - (row.clicks.to_f * row.traffic_cost.to_f)) /
    #           row.clicks.to_f).round(2).to_s + '₽'
    #     end
    #   else
    #     span '-'
    #   end
    # end
    # column 'EPM' do |row|
    #   all = row.money_approve.to_f + row.money_wait.to_f
    #   span (all.to_f / row.views_count.to_f).round(2).to_s + '₽'
    # end
    # column 'REPM' do |row|
    #   span (row.money_approve.to_f / row.views_count.to_f).round(2).to_s + '₽'
    # end
    # column 'CEPM' do |row|
    #   if row.payment_model == 'cpm'
    #     if row.payment_model == 'cpc'
    #       span ((row.money_approve.to_f - ((row.views_count.to_f/1000) * row.traffic_cost.to_f)) /
    #           row.views_count.to_f).round(2).to_s + '₽'
    #     elsif row.payment_model == 'cpm'
    #       span ((row.money_approve.to_f - ((row.views_count.to_f/1000) * row.traffic_cost.to_f)) /
    #           row.views_count.to_f).round(2).to_s + '₽'
    #     end
    #   else
    #     span '-'
    #   end
    # end
    # column 'CR' do |row|
    #   all = row.wait + row.approve + row.decline
    #   if all > 0
    #     span (row.approve.to_f / all.to_f * 100).round(2).to_s + '%'
    #   else
    #     span 0.to_s + '%'
    #   end
    # end
    # column 'Leads (W/A/D)' do |row|
    #   span row.wait.to_s + ' /', style: 'color: blue'
    #   span row.approve.to_s + ' /', style: 'color: green'
    #   span row.decline.to_s, style: 'color: red'
    # end
    # column 'Money (W/A/D)' do |row|
    #   span row.money_wait.to_s + ' /', style: 'color: blue'
    #   span row.money_approve.to_s + ' /', style: 'color: green'
    #   span row.money_decline.to_s, style: 'color: red'
    #   span '₽'
    # end
    # table_for :histories do |r|
    #   columns do
    #     column do |row|
    #       span r
    #     end
    #   end
    # end
  end
  controller do
    before_filter :set_per_page_var, :only => [:index]

    def set_per_page_var
      session[:per_page]=params[:per_page]||1
      @per_page = session[:per_page]
    end

    # def scoped_collection
    #   Campaign.joins('LEFT JOIN clicks as cl ON (campaigns.id = cl.campaign_id AND cl.history_id IS NULL) OR
    #                  campaigns.id = cl.history_id')
    #       .left_outer_joins(:conversions).select(
    #       'campaigns.id, campaigns.name, campaigns.parent_id, campaigns.created_at',
    #       'campaigns.payment_model, campaigns.traffic_cost, campaigns.views_count',
    #       'sum(case when cl.amount > 0 then 1 else 0 end) clicks_count',
    #       'sum(case when cl.activity::int > 0 then 1 else 0 end) actives_count',
    #       'sum(case when cl.amount > 0 then cl.amount else 0 end) hits_count',
    #       'sum(case when conversions.status = 0 then 1 else 0 end) conversions_wait',
    #       'sum(case when conversions.status = 1 then 1 else 0 end) conversions_approve',
    #       'sum(case when conversions.status = 2 then 1 else 0 end) conversions_decline',
    #       'sum(case when conversions.status = 0 then conversions.ext_payout::int else 0 end) money_wait',
    #       'sum(case when conversions.status = 1 then conversions.ext_payout::int else 0 end) money_approve',
    #       'sum(case when conversions.status = 2 then conversions.ext_payout::int else 0 end) money_decline'
    #   ).group('campaigns.parent_id').group('campaigns.id')
    # end
  end
end
