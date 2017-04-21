class Tracker::ConversionController < Tracker::TrackerController
  def create
    visitor = Visitor::get(params[:ip], params[:ua])
    hit_ident = visitor.to_s + params[:ident].to_s
    hit = $hits_cache.get(hit_ident)
    @conversion = Conversion.new
    @conversion.visitor_id = visitor
    if hit
      @conversion.click_id = hit.to_i
    end
    @conversion.client_name = params[:name]
    @conversion.client_phone = params[:phone]
    @conversion.client_address = params[:address]
    @conversion.client_comment = params[:comment]
    @conversion.extra = params[:extra]
    @conversion.status = 0
    if params[:approve]
      @conversion.status = 1
    elsif params[:decline]
      @conversion.status = 2
    end
    @conversion.save
    render json: @conversion
  end
end
