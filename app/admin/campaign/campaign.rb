ActiveAdmin.register Campaign do
  includes :clicks, :conversions
  permit_params :name, :description, :adv_type, :adv_type, :payment_model, :history_action, :integration,
                :traffic_cost, :lead_cost, :incremental_views, :offer_id, :source_id, :landing_id, :views_count,
                :integration_offer, creative_ids: []

  scope 'Parents', default: true do |scope|
    scope.where(:parent_id => nil)
  end
  scope 'With Histories', default: true do |scope|
    scope.reorder('name ASC, id ASC')
  end

  controller do

    def update(options={}, &block)
      campaign = Campaign.find(params[:id])
      orig_creatives = campaign.creatives.dup
      orig_views_count = params[:campaign][:views_count].to_i
      if params[:campaign][:incremental_views] == 'true' and params[:campaign][:views_count].to_i > 0
        orig_views_count = params[:campaign][:views_count].to_i - campaign.get_views_count_from_history
      end
      if params[:campaign][:history_action] == 'create'
        params[:campaign][:views_count] = 0
      else
        params[:campaign][:views_count] = orig_views_count
      end
      super do |success, failure|
        unless success.class.nil?
          if params[:campaign][:history_action] == 'create' and campaign.parent_id.nil?
            campaign.make_history(orig_views_count, orig_creatives)
          end
        end
        block.call(success, failure) if block
        failure.html { render :edit }
      end
    end

    def create(options={}, &block)
      super do |success, failure|
        block.call(success, failure) if block
        failure.html { render :edit }
      end
    end
  end

  index :row_class => -> record { 'index_table_working_campaigns' unless record.parent_id } do
    tabs do
      tab 'Основные' do

      end
    end
    selectable_column
    column :id
    column :name
    column :description
    column :adv_type
    column :incremental_views
    column :payment_model
    column :traffic_cost
    column :lead_cost
    column :views_count do |row|
      span row.get_views_count_from_history(true)
    end
    column :integration
    column :integration_offer
    column :offer do |row|
      link_to row.offer.name, admin_offer_path(row.offer_id)
    end
    column :source do |row|
      link_to row.source.name, admin_source_path(row.source_id)
    end
    column :landing do |row|
      link_to row.landing.name, admin_source_path(row.landing_id)
    end
    column 'Profit' do |row|
      if row.payment_model == 'cpc'
        span ((row.conversions.approved.count.to_f * row.lead_cost.to_f).to_f-
            (row.clicks.count.to_f * row.traffic_cost.to_f).to_f).round(2).to_s + '₽'
      else
        span ((row.conversions.approved.count.to_f * row.lead_cost.to_f).to_f-
            ((row.get_views_count_from_history(true).to_f/1000) * row.traffic_cost.to_f).to_f).round(2).to_s + '₽'
      end
    end
    actions
  end

  show do |s|
    attributes_table do
      row :id
      row :name
      row :description
      row :adv_type
      row :incremental_views
      row :payment_model, as: :string
      row :traffic_cost
      row :lead_cost
      row 'Self views' do
        s.views_count
      end
      if s.parent_id
        row :parent_id
      else
        row 'Total Views' do
          span s.get_views_count_from_history(true)
        end
      end
      row :integration
      row :integration_offer
      row :offer
      row :source
      row :landing
    end
    panel 'Creatives' do
      table_for s.creatives do
        column :title
        column :text
        column :description
        column 'Image' do |img|
          image_tag(img.image.url(:thumb))
        end
      end
    end
    panel 'General Statistics' do
      clicks = s.clicks.count
      views_count = s.get_views_count_from_history(true)
      approve = s.conversions.approved.count
      wait = s.conversions.waiting.count
      decline = s.conversions.approved.count
      money_approve = (approve * s.lead_cost).to_i
      money_wait = (wait * s.lead_cost).to_i
      money_decline = (decline * s.lead_cost).to_i
      table_for s do
        column 'Name' do
          link_to s.name, admin_campaign_path(s.id)
        end
        column 'Clicks' do
          clicks
        end
        column 'Actives' do
          s.clicks.count('activity')
        end
        column 'Hits' do
          s.clicks.sum('amount')
        end
        column 'Views' do
          views_count
        end
        column 'CTR' do
          if clicks > 0
            span (clicks.to_f / views_count.to_f).round(3).to_s + '%'
          else
            span '-'
          end
        end
        column 'EPC' do
          if clicks > 0
            all = money_approve.to_f + money_wait.to_f
            span (all.to_f / clicks.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        column 'REPC' do
          if clicks > 0
            span (money_approve.to_f / clicks.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        column 'CEPC' do
          if clicks > 0
            if s.payment_model == 'cpc'
              span ((money_approve.to_f - (clicks.to_f * s.traffic_cost.to_f))).round(2).to_s + '₽'
            else
              span '-'
            end
          else
            span '-'
          end
        end
        column 'EPM' do
          if views_count > 0
            all = money_approve.to_f + money_wait.to_f
            span (all.to_f / views_count.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        column 'REPM' do
          if views_count > 0
            span (money_approve.to_f / views_count.to_f).round(2).to_s + '₽'
          else
            span '-'
          end
        end
        column 'CEPM' do
          if views_count > 0
            if s.payment_model == 'cpm'
              span ((money_approve.to_f - ((views_count.to_f/1000) * s.traffic_cost.to_f))).round(2).to_s + '₽'
            else
              span '-'
            end
          else
            span '-'
          end
        end
        column 'CR' do
          all = wait + approve + decline
          if all > 0
            span (approve.to_f / all.to_f * 100).round(2).to_s + '%'
          else
            span 0.to_s + '%'
          end
        end
        column 'Leads (W/A/D)' do
          span wait.to_s + ' /', style: 'color: blue'
          span approve.to_s + ' /', style: 'color: green'
          span decline.to_s, style: 'color: red'
        end
        column 'Money (W/A/D)' do
          span money_wait.to_s + ' /', style: 'color: blue'
          span money_approve.to_s + ' /', style: 'color: green'
          span money_decline.to_s, style: 'color: red'
          span '₽'
        end
      end
    end
    panel 'Splited Statistics' do
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
      ).where("campaigns.id = #{s.id} OR campaigns.parent_id = #{s.id}")
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
            span (row.clicks_count.to_f / row.views_count.to_f).round(3).to_s + '%'
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
            span (row.conversions_money_approve.to_f - (row.clicks_count.to_f * row.traffic_cost.to_f)).round(2).to_s + '₽'
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
            span (row.conversions_money_approve.to_f - ((row.views_count.to_f/1000) * row.traffic_cost.to_f)).round(2).to_s + '₽'
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
    active_admin_comments
  end

  form do |f|
    f.semantic_errors
    tabs do
      tab 'Основные' do
        f.inputs do
          f.input :name
          f.input :description
          f.input :adv_type
          if f.object.new_record?
            f.input :incremental_views
          else
            f.input :incremental_views, as: :hidden
          end
          f.input :payment_model, as: :select, :collection => {'Cost Per Click' => 'cpc', 'Cost Per Mile' => 'cpm'}, include_blank: true, allow_blank: false
          f.input :traffic_cost
          f.input :lead_cost
          if f.object.new_record?
            f.inputs do
              f.input :offer_id, as: :select, :collection => Offer.all.map { |o| [o.name, o.id] }, :include_blank => false
              f.input :source_id, as: :select, :collection => Source.all.map { |o| [o.name, o.id] }, :include_blank => false
              f.input :landing_id, as: :select, :collection => Landing.all.map { |o| [o.name, o.id] }, :include_blank => false
            end
          else
            if f.object.incremental_views
              f.input :views_count, :input_html => {:value => f.object.get_views_count_from_history(true)}
            else
              f.input :views_count
            end
          end
        end
      end
      tab 'Интеграция' do
        f.inputs do
          f.input :integration, as: :select, :collection => {'Tligth' => 'tlight'}, include_blank: true, allow_blank: true
          f.input :integration_offer
        end
      end
      unless f.object.new_record?
        tab 'Креативы' do
          f.inputs do
            # f.has_many :creatives, as: :check_boxes, new_record: true do |t|
            #     t.input :id
            # end
            f.input :creatives, as: :check_boxes do |row|
              row.input :id, as: :check_boxes
            end
          end
        end
      end
    end
    unless f.object.new_record? or f.object.parent_id
      f.inputs do
        f.input :history_action, as: :select, :collection => {'Не создавать историю' => false, 'Создать историю' => 'create'}, include_blank: false
      end
    end
    f.actions
  end
end

