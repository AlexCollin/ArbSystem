class SetVisitorToConversions < ActiveRecord::Migration[5.0]
  def self.up
    Conversion.all.each do |c|
      if c.click_id
        c.visitor_id = c.click.visitor_id
        c.save
      end
    end
  end
end
