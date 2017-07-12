ActiveAdmin.register Click, as: 'Statistics' do
  includes :conversions

  menu :priority => 2
  menu label: "Statistics"

  # controller do
  #   def scoped_collection
  #     Click.includes(:visitor)
  #   end
  # end

end
