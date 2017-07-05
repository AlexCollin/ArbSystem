class AddUtmToClicks < ActiveRecord::Migration[5.0]
  def change
    add_column :clicks, :utm_source, :string, default: nil
    add_column :clicks, :utm_medium, :string, default: nil
    add_column :clicks, :utm_campaign, :string, default: nil
    add_column :clicks, :utm_content, :string, default: nil
    add_column :clicks, :utm_term, :string, default: nil
  end
end
