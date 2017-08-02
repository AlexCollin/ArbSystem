class Tracker::ConversionController < Tracker::TrackerController
  def create
    click_model = Click.find(params[:click])
    if click_model
      @conversion = Conversion.new
      @conversion.visitor_id = click_model.visitor_id
      @conversion.click_id = click_model.id
      @conversion.campaign_id = click_model.campaign_id
      @conversion.creative_id = click_model.creative_id
      @conversion.client_name = params[:name]
      @conversion.client_phone = params[:phone]
      @conversion.client_address = params[:address]
      @conversion.client_comment = params[:comment]
      @conversion.payout = params[:payout] if params[:payout]
      unless @conversion.payout
        @conversion.payout = (click_model.campaign.lead_cost).to_f
      end
      @conversion.extra = params[:extra]
      @conversion.status = 0
      if params[:approve]
        @conversion.status = 1
      elsif params[:decline]
        @conversion.status = 2
      end
      if @conversion.save
        render json: @conversion
      else
        render json: @conversion.errors
      end
    else
      Issue.create!(:name => 'Click not found', :data => params.to_s, :type => 'conversion')
      render json: {status: 'error', message: 'Click not found'}
    end
  end
end
