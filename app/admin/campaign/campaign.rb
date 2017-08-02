ActiveAdmin.register Campaign do
  includes :clicks, :conversions
  permit_params :name, :description, :adv_type, :adv_type, :payment_model, :history_action, :integration,
                :traffic_cost, :lead_cost, :incremental_views, :offer_id, :source_id, :landing_id, :views,
                :integration_offer, :calculate_views_on_creatives, :total_views, :ext_id, creative_ids: [],
                campaigns_creatives_attributes: [:creative_id, :views, :total_views, :id, :_destroy, :ext_id]

  scope 'Workings', default: true do |scope|
    scope.where(:parent_id => nil)
  end
  scope 'With Histories', default: true do |scope|
    scope.reorder('name ASC, id ASC')
  end

  controller do

    def update(options={}, &block)
      campaign = Campaign.find(params[:id])
      if params[:campaign][:calculate_views_on_creatives] == 'true'
        orig_history_views = 0
        orig_views_count = 0
      else
        views = params[:campaign][:views].to_i
        his = campaign.get_views_count_from_history(false)
        orig_history_views = views
        orig_views_count = views - his
      end

      orig_campaigns_creatives = params[:campaign][:campaigns_creatives_attributes].dup

      orig_campaigns_creatives.each do |index|
        cca = orig_campaigns_creatives[index]
        history_ca = CampaignsCreative.get_total_views(cca[:creative_id], campaign.id, false)

        cca[:total_views] = cca[:views].to_i
        cca[:views] = cca[:views].to_i - history_ca

        if params[:campaign][:calculate_views_on_creatives] == 'true'
          orig_views_count += cca[:views]
          orig_history_views += cca[:total_views]
        end

        ccm = params[:campaign][:campaigns_creatives_attributes][index]
        ccm[:views] = cca[:views].to_i
        ccm[:total_views] = cca[:total_views]
      end

      params[:campaign][:total_views] = orig_history_views
      params[:campaign][:views] = orig_views_count

      if params[:campaign][:history_action] == 'create'
        params[:campaign][:views] = 0
        params[:campaign][:campaigns_creatives_attributes].each do |index|
          params[:campaign][:campaigns_creatives_attributes][index][:views] = 0
        end
      end

      super do |success, failure|
        unless success.class.nil?
          if params[:campaign][:history_action] == 'create'
            history = campaign.dup
            history.parent_id = campaign.id
            history.views = orig_views_count
            history.total_views = orig_history_views
            history.save

            orig_campaigns_creatives.each do |c|
              occ = orig_campaigns_creatives[c]
              history.campaigns_creatives.create(
                  :views => occ[:views].to_i,
                  :total_views => occ[:total_views].to_i,
                  :campaign_id => history.id,
                  :creative_id => occ[:creative_id].to_i,
                  :working_campaign_id => campaign.id
              ).save
            end

            Click.where(:campaign_id => campaign.id).update_all(campaign_id: history.id)
            Conversion.where(:campaign_id => campaign.id).update_all(campaign_id: history.id)
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
    selectable_column
    column :id
    column :name
    column :description
    column :adv_type
    column :incremental_views
    column :payment_model
    column :traffic_cost
    column :lead_cost
    column :ext_id
    column :views do |row|
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
    tabs do
      tab 'Информация' do
        attributes_table do
          row :id
          row :name
          row :description
          row :adv_type
          row :incremental_views
          row :calculate_views_on_creatives
          row :payment_model, as: :string
          row :traffic_cost
          row :lead_cost
          row 'Self views' do
            s.views
          end
          if s.parent_id
            row :parent_id
          else
            row 'Total Views' do
              span s.total_views
            end
          end
          row :integration
          row :integration_offer
          row :ext_id
          row :offer
          row :source
          row :landing
        end
        panel 'Creatives' do
          table_for s.campaigns_creatives do
            column :id
            column :title do |row|
              span row.creative.title
            end
            column :text do |row|
              span row.creative.text
            end
            column :description do |row|
              span row.creative.description
            end
            column :total_views do |row|
              span row.total_views
            end
            column :views do |row|
              span row.views
            end
            column :ext_id
            column 'Image' do |img|
              image_tag(img.creative.image.url(:thumb))
            end
          end
        end
      end
      tab 'Статистика' do
        panel 'General Statistics' do
          clicks = s.all_clicks.count
          views_count = s.get_views_count_from_history(true)
          approve = s.conversions.approved.count
          wait = s.conversions.waiting.count
          decline = s.conversions.declined.count
          money_approve = (s.conversions.approved.sum(:payout)).to_i
          money_wait = (s.conversions.waiting.sum(:payout)).to_i
          money_decline = (s.conversions.declined.sum(:payout)).to_i
          # raw table_for_campaign(s, clicks, s.clicks.count('activity'), s.clicks.sum('amount'),
          #                        views, s.traffic_cost, false, approve, decline, wait, money_wait,
          #                        money_approve, money_decline)
          table_for s do
            column 'Name' do
              link_to s.name, admin_campaign_path(s.id)
            end
            column 'Clicks/Active/Hits' do
              span clicks
              span '/'
              span s.all_clicks.count('activity').to_i
              span '/'
              span s.all_clicks.sum('amount')
            end
            column 'Views' do
              span views_count
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
        unless s.parent_id
          panel 'Splited Statistics' do
            childs = Campaign.joins('LEFT OUTER JOIN clicks ON clicks.campaign_id = campaigns.id',
                                    'LEFT OUTER JOIN conversions ON conversions.click_id = clicks.id').select(
                'campaigns.id, campaigns.name, campaigns.parent_id, campaigns.created_at',
                'campaigns.payment_model, campaigns.traffic_cost, campaigns.views, campaigns.total_views',
                'sum(CASE WHEN clicks.amount > 0 AND conversions.id IS NULL THEN 1 ELSE 0 END) clicks_count',
                'sum(case when clicks.activity::int > 0 then 1 else 0 end) actives_count',
                'sum(case when clicks.amount > 0 then clicks.amount else 0 end) hits_count',
                'sum(case when conversions.click_id = clicks.id then 1 else 0 end) conversions_all',
                'sum(case when conversions.status = 0 AND conversions.click_id = clicks.id then 1 else 0 end) conversions_wait',
                'sum(case when conversions.status = 1 AND conversions.click_id = clicks.id then 1 else 0 end) conversions_approve',
                'sum(case when conversions.status = 2 AND conversions.click_id = clicks.id then 1 else 0 end) conversions_decline',
                'sum(case when conversions.status = 0 AND conversions.click_id = clicks.id then conversions.payout::int else 0 end) conversions_money_wait',
                'sum(case when conversions.status = 1 AND conversions.click_id = clicks.id then conversions.payout::int else 0 end) conversions_money_approve',
                'sum(case when conversions.status = 2 AND conversions.click_id = clicks.id then conversions.payout::int else 0 end) conversions_money_decline'
            ).group('campaigns.id').where('conversions.id IS NULL OR clicks.id IS NOT NULL')
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
              column 'Clicks/Active/Hits' do |row|
                span row.clicks_count
                span '/'
                span row.actives_count
                span '/'
                span row.hits_count
              end
              column 'Views' do |row|
                span row.views.to_s
              end
              column 'CTR' do |row|
                if row.views > 0 and row.clicks_count > 0
                  span (row.clicks_count.to_f / row.views.to_f).round(3).to_s + '%'
                else
                  span '-'
                end
              end
              column 'EPC' do |row|
                if row.clicks_count > 0
                  all = row.conversions_money_approve.to_f + row.conversions_money_wait.to_f
                  span (all.to_f / row.clicks_count.to_f).round(2).to_s + '₽'
                else
                  span '-'
                end
              end
              column 'REPC' do |row|
                if row.views > 0 and row.clicks_count > 0
                  span (row.conversions_money_approve.to_f / row.clicks_count.to_f).round(2).to_s + '₽'
                else
                  span '-'
                end
              end
              column 'CEPC' do |row|
                if row.views > 0 and row.payment_model == 'cpc' and row.clicks_count > 0
                  span (row.conversions_money_approve.to_f - (row.clicks_count.to_f * row.traffic_cost.to_f)).round(2).to_s + '₽'
                else
                  span '-'
                end
              end
              column 'EPM' do |row|
                if row.views > 0
                  all = row.conversions_money_approve.to_f + row.conversions_money_wait.to_f
                  span (all.to_f / row.views.to_f).round(2).to_s + '₽'
                else
                  span '-'
                end
              end
              column 'REPM' do |row|
                if row.views > 0
                  span (row.conversions_money_approve.to_f / row.views.to_f).round(2).to_s + '₽'
                else
                  span '-'
                end
              end
              column 'CEPM' do |row|
                if row.views > 0 and row.payment_model == 'cpm'
                  span (row.conversions_money_approve.to_f - ((row.views.to_f/1000) * row.traffic_cost.to_f)).round(2).to_s + '₽'
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
            f.input :calculate_views_on_creatives
          else
            f.input :incremental_views, as: :hidden
            f.input :calculate_views_on_creatives, as: :hidden
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
            unless f.object.calculate_views_on_creatives
              if f.object.incremental_views
                f.input :views, :input_html => {:value => f.object.get_views_count_from_history(true)}
              else
                f.input :views
              end
            end
          end
        end
      end
      tab 'Интеграция' do
        f.inputs do
          f.input :integration, as: :select, :collection => {'Tligth' => 'tlight'}, include_blank: true, allow_blank: true
          f.input :integration_offer
          f.input :ext_id
        end
      end
      tab 'Креативы' do
        f.inputs do
          # f.has_many :creatives, as: :check_boxes, new_record: true do |t|
          #     t.input :id
          # end
          # f.input :creatives, as: :check_boxes do |row|
          #   row.input :id, as: :check_boxes
          f.has_many :campaigns_creatives, new_record: true, allow_destroy: true do |cf|
            cf.input :id, as: :hidden
            cf.input :creative_id, as: :select, :collection => Creative.all.map { |o| [o.title, o.id] }, :include_blank => true
            cf.input :views, :input_html => {:value => cf.object.get_total_views(true)}
            cf.input :ext_id
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

  # sidebar 'User Details', :only => :show do
  #   attributes_table_for campaign do
  #     :name
  #   end
  # end
end

