class Tracker::ClickController < Tracker::TrackerController

  def create
    visitor = Visitor::get(params[:ip], params[:ua])
    hit_ident = visitor.to_s + params[:ident].to_s
    hit = $hits_cache.get(hit_ident)
    if hit
      click = Click.find(hit.to_i)
      click.amount += 1
      click.updated_at = Time.now
      click.save
    else
      click = Click.new
      click.visitor_id = visitor
      click.referer = params[:referer]
      click.cpc = params[:cpc].to_f.round(2)
      click.amount = 1
      click.s1 = params[:s1] if params[:s1]
      click.s2 = params[:s2] if params[:s2]
      click.s3 = params[:s3] if params[:s3]
      click.s4 = params[:s4] if params[:s4]
      click.s5 = params[:s5] if params[:s5]
      click.s6 = params[:s6] if params[:s6]
      click.s7 = params[:s7] if params[:s7]
      click.s8 = params[:s8] if params[:s8]
      click.s9 = params[:s9] if params[:s9]
      click.save
      $hits_cache.set(hit_ident, click.id, {ex: 1.day})
    end
    render json: click
  end

  def activity
    visitor = Visitor::get(params[:ip], params[:ua])
    hit_ident = visitor.to_s + params[:ident].to_s
    hit = $hits_cache.get(hit_ident)
    if hit
      click = Click.find(hit.to_i)
      if click
        click.activity = click.activity.to_i + 1
        click.save
        render json: click
      end
    end
  end
end
