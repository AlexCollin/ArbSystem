class AddExecjsToClicks < ActiveRecord::Migration[5.0]
  def change
    add_column :clicks, :is_load_js, :boolean, default: false
  end
end
