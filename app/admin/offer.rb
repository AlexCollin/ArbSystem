ActiveAdmin.register Offer do
  includes :categories

  permit_params :name, categories_attributes: [:name], category_ids: []

  remove_filter :categories_offers

  index do
    selectable_column
    index_column
    column :name
    column :categories do |row|
      raw(row.categories.map { |c| link_to c.name, admin_category_path(c) }.join(', '))
    end

    actions
  end

  form do |f|
    f.semantic_errors
    tabs do
      tab 'Основные' do
        f.inputs
      end

      tab 'Категории' do
        f.inputs do
          # f.has_many :categories, heading: 'Категории',
          #            new_record: false,
          #            allow_destroy: true do |a|
          #   a.input :name, label: 'Name', as: :select, :collection =>
          #       Category.all.map { |cat| [cat.name, cat.name] }
          # end
          f.input :categories, as: :check_boxes, :collection => Category.all.map { |cat| [cat.name, cat.id] }
        end
      end
    end
    f.actions
  end
end
