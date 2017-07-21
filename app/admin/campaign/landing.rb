ActiveAdmin.register Landing do
  permit_params :name, :url, :is_external, :is_transit

  menu parent: 'Campaigns'

end
