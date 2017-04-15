class Tracker::ClickController < Tracker::TrackerController

  def create
    client_ident = Digest::MD5.hexdigest(
        params[:ip].to_s+params[:ua].to_s+params[:s1].to_s+params[:s2].to_s+
            params[:s3].to_s+params[:s4].to_s+params[:s5].to_s+params[:s6].to_s+
            params[:s7].to_s+params[:s9].to_s+params[:s9].to_s)

    @click = Click.where(:ident => client_ident).order('created_at DESC').first
    if @click and @click.created_at >= 1.day.ago
      @click.amount += 1
      @click.updated_at = Time.now
    else
      @click = Click.new
      @click.ip = params[:ip]
      @click.ua = params[:ua]
      @click.ident = client_ident
      @click.referer = params[:referer]
      @click.cpc = params[:cpc].to_f.round(2)
      @click.amount = 1
      @click.s1 = params[:s1]
      @click.s2 = params[:s2]
      @click.s3 = params[:s3]
      @click.s4 = params[:s4]
      @click.s5 = params[:s5]
      @click.s6 = params[:s6]
      @click.s7 = params[:s7]
      @click.s8 = params[:s8]
      @click.s9 = params[:s9]
    end
    @click.save
    render json: @click
  end

end
