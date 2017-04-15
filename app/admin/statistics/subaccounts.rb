ActiveAdmin.register Click, as: 'SubAccount' do
  actions :all, only: []


  menu parent: "Statistics"

  scope 's1', default: true do |scope|
    scope.select('s1').group('clicks.s1').reorder('s1')
  end
  scope 's2' do |scope|
    scope.select('s2').group('clicks.s2').reorder('s2')
  end
  scope 's3' do |scope|
    scope.select('s3').group('clicks.s3').reorder('s3')
  end
  scope 's4' do |scope|
    scope.select('s4').group('clicks.s4').reorder('s4')
  end
  scope 's5' do |scope|
    scope.select('s5').group('clicks.s5').reorder('s5')
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
      scope = 's1'
    end
    column scope
    column :clicks
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
      Click.left_joins(:conversions)
          .select(
              'sum(case when clicks.amount > 0 then 1 else 0 end) clicks',
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
