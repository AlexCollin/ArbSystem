class Tracker::ConversionController < Tracker::TrackerController
  def create
    @conversion = Conversion.new
    @conversion.click_id = params[:click]
    @conversion.client_name = params[:name]
    @conversion.client_phone = params[:phone]
    @conversion.client_address = params[:address]
    @conversion.client_comment = params[:comment]
    @conversion.extra = params[:extra]
    @conversion.status = 0
    @conversion.save
    if stale?(last_modified: @conversion.created_at, public: true)
      render json: @conversion
    end
  end
end
