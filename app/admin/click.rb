ActiveAdmin.register Click do
  menu parent: 'Traffic'
  includes :conversions

  # menu :priority => 2

  # controller do
  #   def scoped_collection
  #     Click.includes(:visitor)
  #   end
  # end

end
