ActiveAdmin.register Click, as: 'StatisticsForCreatives' do
  includes :creative
  menu parent: "Statistics", label: 'Creatives'
  actions :index
  scope 'All', default: true do |scope|
    scope.group('clicks.creative_id')
        .reorder('clicks.creative_id ASC')
  end
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


  # before_filter :only => [:index] do
  #   if params['working_campaign_id'].blank? and (not params['q'] or params['q']['working_campaign_id_eq'].blank?)
  #     params['q'] = {'working_campaign_id_eq' => Campaign.where('campaigns.parent_id IS NULL')&.last&.id || ''}
  #   end
  # end
  #
  # filter :working_campaign, :collection => Campaign.where('campaigns.parent_id IS NULL').map { |o| [o.name, o.id] }, :include_blank => false
  # filter :created_at
  preserve_default_filters!
  remove_filter :working_campaign
  filter :campaign, :collection => Campaign.all.map { |o| [("#{o.id} #{o.name}"), o.id] }, :include_blank => true

  index do
    column 'Creative' do |row|
      if row.creative
        link_to row.creative_id, admin_creative_path(row.creative_id)
      else
        span row.creative_id
      end
    end
    column 'Clicks/Views' do |row|
      span row.clicks
      span '/'
      if row.creative_id
        span (row.creatives_views).to_i
      else
        span '-'
      end
    end
    column 'CTR' do |row|
      if (row.creatives_views).to_i > 0
        span (row.clicks.to_f / (row.creatives_views).to_f).round(3).to_s + '%'
      else
        span '-'
      end
    end
    column 'Title/Text' do |row|
      if row.creative
        b "#{row.creative.title}\n"
        div row.creative.text
      else
        span '-'
      end
    end
    column 'Image' do |img|
      if img.creative
        image_tag(img.creative.image.url(:thumb))
      else
        span '-'
      end
    end
    column 'Descr' do |row|
      if row.creative
        span row.creative.description
      else
        span '-'
      end
    end
  end

  controller do
    def scoped_collection
      Click.left_outer_joins(:conversions)
          .select(
              'clicks.creative_id',
              'sum(case when clicks.amount > 0 then 1 else 0 end) clicks',
              'sum(case when clicks.activity::int > 0 then 1 else 0 end) actives',
              'sum(case when clicks.amount > 0 then clicks.amount else 0 end) hits'
          ).where('clicks.creative_id::int > 0')
    end
  end
end
