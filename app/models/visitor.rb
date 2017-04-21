class Visitor < ApplicationRecord
  has_many :clicks
  has_many :conversions

  def self.get(ip,ua)
    ident = Digest::MD5.hexdigest(ip.to_s+ua.to_s)
    visitor = Visitor.find_by(:ident => ident)
    unless visitor
      visitor = Visitor.new
      visitor.ip = ip.to_s
      visitor.ua = ua.to_s
      visitor.ident = ident
      visitor.save
    end
    visitor.id
  end
end
