ActiveAdmin.register Creative do
  menu parent: 'Campaigns'

  permit_params :title, :text, :description, :offer_id, :image


  show do |c|
    attributes_table do
      row :title
      row :image do |img|
        image_tag(img.image.url(:medium))
      end
    end
    panel "Оффер" do
      attributes_table_for c.offer do
        row :name
      end
    end
    active_admin_comments
  end

  index do
    selectable_column
    id_column
    column :title
    column :text
    column :description
    column :offer do |row|
      link_to row.offer.name, admin_offer_path(row.offer_id)
    end
    column 'Image', sortable: :image_file_name do |img|
      image_tag(img.image.url(:thumb))
    end
    column :image_file_size, sortable: :image_file_size do |img|
      "#{img.image_file_size} KB"
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Information" do
      f.input :title
      f.input :text
      f.input :description
      f.input :offer_id, as: :select, :collection => Offer.all.map { |o| [o.name, o.id] }, include_blank: true, allow_blank: false
    end
    f.inputs "Upload" do
      f.input :image, required: true, as: :file
    end
    f.actions
  end

end
