ActiveAdmin.register Campaign do
  permit_params :name, :description, :adv_type, :adv_type, :payment_model, :history_action,
                :traffic_cost, :lead_cost, :incremental_views, :offer_id, :source_id, :views_count,
                creative_ids: []

  controller do
    def scoped_collection
      Campaign.where(:parent_id => nil)
    end

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

  index do
    selectable_column
    index_column
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
    column :offer do |row|
      link_to row.offer.name, admin_offer_path(row.offer_id)
    end
    column :source do |row|
      link_to row.source.name, admin_source_path(row.source_id)
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
        row :parent
      else
        row 'Total Views' do
          span s.get_views_count_from_history(true)
        end
      end
      row :offer
      row :source
    end
    table_for s.creatives do
      column :title
      column :text
      column :description
      column 'Image' do |img|
        image_tag(img.image.url(:thumb))
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
    unless f.object.new_record?
      f.inputs do
        f.input :history_action, as: :select, :collection => {'Не создавать историю' => false, 'Создать историю' => 'create'}, include_blank: false
      end
    end
    f.actions
  end
end

