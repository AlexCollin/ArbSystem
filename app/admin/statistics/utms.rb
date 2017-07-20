ActiveAdmin.register Click, as: 'StatisticsForUtm' do
  actions :all, only: []


  menu parent: 'Statistics', label: 'Utm quotes'

  scope 'Source', default: true do |scope|
    scope.select('utm_source').group('clicks.utm_source').reorder('utm_source')
  end
  scope 'Medium' do |scope|
    scope.select('utm_medium').group('clicks.utm_medium').reorder('utm_medium')
  end
  scope 'Campaign' do |scope|
    scope.select('utm_campaign').group('clicks.utm_campaign').reorder('utm_campaign')
  end
  scope 'Content' do |scope|
    scope.select('utm_content').group('clicks.utm_content').reorder('utm_content')
  end
  scope 'Term' do |scope|
    scope.select('utm_term').group('clicks.utm_term').reorder('utm_term')
  end

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
  index do
    scope = params[:scope]
    unless scope
      scope = 'Source'
    end
    column scope
    column :clicks
    column :actives
    column :hits
    column 'CR' do |row|
      all = row.wait + row.approve + row.decline
      if all > 0
        span (row.approve.to_f / all.to_f * 100).round(2).to_s + '%'
      else
        span 0.to_s + '%'
      end
    end
    column 'EPC' do |row|
      span (row.money_approve.to_f / row.clicks.to_f).round(2).to_s + '₽'
    end
    column 'EPC2' do |row|
      all = row.money_approve.to_f + row.money_wait.to_f + row.money_decline.to_f
      span (all.to_f / row.clicks.to_f).round(2).to_s + '₽'
    end
    column :wait
    column :approve
    column :decline
    column :money_wait do |row|
      span row.money_wait.to_s + '₽'
    end
    column :money_approve do |row|
      span row.money_approve.to_s + '₽'
    end
    column :money_decline do |row|
      span row.money_decline.to_s + '₽'
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
