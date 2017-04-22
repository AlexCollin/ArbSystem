class RenameIsJsLoadInClicks < ActiveRecord::Migration[5.0]
  def self.up
    add_column :clicks, :activity, :integer
    Click.all.each do |click|
      if click.is_load_js ==
        click.activity = 1
      end
    end
    remove_column :clicks, :is_load_js
  end
  def self.down
    add_column :clicks, :is_load_js, :boolean
    Click.all.each do |click|
      if click.activity > 0
        click.is_load_js = true
      end
    end
    remove_column :clicks, :activity
  end
end
