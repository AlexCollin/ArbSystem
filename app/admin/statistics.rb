ActiveAdmin.register Click, as: 'Statistics' do
  includes :conversions

  menu :priority => 2
  menu label: "Statistics"

end
