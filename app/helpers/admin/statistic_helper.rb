module Admin::StatisticHelper
  include ActiveAdmin::Views

  def table_for_campaign(resource, clicks = 0, actives = 0, hits = 0, views = 0,
                         traffic_cost = 0, payment_model = '', approve = 0, decline = 0, wait = 0, money_wait = 0,
                         money_approve = 0, money_decline = 0)
    table_for resource do
      column 'Name' do
        link_to resource.name, admin_campaign_path(resource.id)
      end
      unless payment_model.empty?
        column 'Model' do

        end
      end
      column 'Clicks' do
        clicks
      end
      column 'Actives' do
        actives
      end
      column 'Hits' do
        hits
      end
      column 'Views' do
        views
      end
      column 'CTR' do
        if clicks > 0
          span (clicks.to_f / views.to_f).round(3).to_s + '%'
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
            span ((money_approve.to_f - (clicks.to_f * traffic_cost.to_f))).round(2).to_s + '₽'
          else
            span '-'
          end
        else
          span '-'
        end
      end
      column 'EPM' do
        if views > 0
          all = money_approve.to_f + money_wait.to_f
          span (all.to_f / views.to_f).round(2).to_s + '₽'
        else
          span '-'
        end
      end
      column 'REPM' do
        if views > 0
          span (money_approve.to_f / views.to_f).round(2).to_s + '₽'
        else
          span '-'
        end
      end
      column 'CEPM' do
        if views > 0
          if payment_model == 'cpm'
            span ((money_approve.to_f - ((views.to_f/1000) * traffic_cost.to_f))).round(2).to_s + '₽'
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
end