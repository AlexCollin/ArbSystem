class Tracker::ClickController < Tracker::TrackerController

  def create
    visitor = Visitor::get(params[:ip], params[:ua])
    hit_ident = visitor.to_s + params[:landing].to_s
    hit = $hits_cache.get(hit_ident)
    if hit
      render json: Click.find(hit.to_i).increment!(:amount, 1)
    else
      click = Click.new
      click.visitor_id = visitor
      click.referer = params[:referer]
      click.cpc = params[:cpc].to_f.round(2)
      click.amount = 1
      click.utm_source = params[:utm_source] if params[:utm_source]
      click.utm_medium = params[:utm_medium] if params[:utm_medium]
      click.utm_campaign = params[:utm_campaign] if params[:utm_campaign]
      click.utm_content = params[:utm_content] if params[:utm_content]
      click.utm_term = params[:utm_term] if params[:utm_term]
      click.s1 = params[:s1] if params[:s1]
      click.s2 = params[:s2] if params[:s2]
      click.s3 = params[:s3] if params[:s3]
      click.s4 = params[:s4] if params[:s4]
      click.s5 = params[:s5] if params[:s5]
      click.s6 = params[:s6] if params[:s6]
      click.s7 = params[:s7] if params[:s7]
      click.s8 = params[:s8] if params[:s8]
      click.s9 = params[:s9] if params[:s9]
      if params[:campaign].to_i > 0
        click.campaign_id = params[:campaign].to_i
        if params[:creative].to_i > 0
          click.creative_id = params[:creative].to_i
        end
      else
        if params[:utm_campaign].to_i > 0
          source = Source.where(:code => params[:utm_source]).first
          if source
            campaign = Campaign.where(source_id: source.id, :ext_id => params[:utm_campaign], :parent_id => nil).first
            if campaign
              click.campaign_id = campaign.id
              if params[:utm_content].to_i > 0
                creative = CampaignsCreative.where(:campaign_id => campaign.id, :ext_id => params[:utm_content]).first
                if creative
                  click.creative_id = creative.creative_id
                else
                  Issue.create!(:name => 'Creative not found', :data => params.to_s, :type => 'click')
                  render json: {status: 'error', message: 'Creative not found'}
                end
              end
            else
              Issue.create!(:name => 'Campaign not found', :data => params.to_s, :type => 'click')
              render json: {status: 'error', message: 'Campaign not found'}
            end
          else
            Issue.create!(:name => 'Source not found', :data => params.to_s, :type => 'click')
            render json: {status: 'error', message: 'Source not found'}
          end
        end
      end
      if click.save
        $hits_cache.set(hit_ident, click.id, {ex: 1.day})
        render json: click
      else
        render json: click.errors
      end
    end
  end

  def activity
    visitor = Visitor::get(params[:ip], params[:ua])
    hit_ident = visitor.to_s + params[:landing].to_s
    hit = $hits_cache.get(hit_ident)
    if hit
      click = Click.find(hit.to_i)
      if click
        click.activity = (Time.now - click.created_at).to_s
        click.save
        render json: click
      end
    end
  end
end
