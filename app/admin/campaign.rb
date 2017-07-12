ActiveAdmin.register Campaign do
  permit_params :name, :description, :adv_type, :adv_type, :payment_model,
                :traffic_cost, :lead_cost, :incremental_views, :offer_id, :source_id, :views_count

  controller do
    def scoped_collection
      Campaign.where(:parent_id => nil)
    end
    def update(options={}, &block)
      campaign = Campaign.find(params[:id])
      views_count = params[:campaign][:views_count]
      if params[:campaign][:incremental_views].to_i == 1 and params[:campaign][:views_count].to_i > 0
        views_count = params[:campaign][:views_count].to_i - Campaign.get_views_count_from_history(campaign.id)
      end
      params[:campaign][:views_count] = 0
      super do |success, failure|
        unless success.class.nil?
          history = campaign.dup # clone model
          history.parent_id = campaign.id
          history.views_count = views_count
          if history.save
            Click.where(history_id: nil, campaign_id: params[:id])
                .update_all(history_id: history.id)
            Click.where(history_id: nil, campaign_id: params[:id])
                .update_all(history_id: history.id)
          else
            p history.errors
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
    column :name
    column :description
    column :adv_type
    column :incremental_views
    column :payment_model
    column :traffic_cost
    column :lead_cost
    column :views_count do |row|
      span Campaign.get_views_count_from_history(row.id)
    end
    column :offer do |row|
      link_to row.offer.name, admin_offer_path(row.offer_id)
    end
    column :source do |row|
      link_to row.source.name, admin_source_path(row.source_id)
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description
      f.input :adv_type
      f.input :incremental_views
      f.input :payment_model
      f.input :traffic_cost
      f.input :lead_cost
      if f.object.new_record?
        f.inputs do
          f.input :offer_id, as: :select, :collection => Offer.all.map { |o| [o.name, o.id] }, :include_blank => false
          f.input :source_id, as: :select, :collection => Source.all.map { |o| [o.name, o.id] }, :include_blank => false
        end
      else
        if f.object.incremental_views
          f.input :views_count, :input_html => {:value => Campaign.get_views_count_from_history(params[:id])}
        else
          f.input :views_count
        end
      end

    end

    f.actions
  end
end

