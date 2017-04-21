class TransferIdentsToVisitors < ActiveRecord::Migration[5.0]
  def self.up
    Click.all.each do |click|
      client_ident = Digest::MD5.hexdigest(click.ip.to_s+click.ua.to_s)
      @visitor = Visitor.find_by(:ident => client_ident)
      unless @visitor
        @visitor = Visitor.new
        @visitor.ip = click.ip.to_s
        @visitor.ua = click.ua.to_s
        @visitor.ident = client_ident
        @visitor.save
      end
      click.visitor_id = @visitor.id
      click.save
    end
  end
end
