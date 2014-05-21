class CasesController < ApplicationController
  respond_to :json

  def index
    since = params[:since] || ''
    status = params[:status] || ''
    category = params[:category] || ''
    near = params[:near] || ''
    
    conditions = []
    condition_values = {}

    if since != ''
      conditions << "cases.opened = :since"
      condition_values[:since] = Time.at(since.to_i).utc.to_s
    end

    if status != ''
      conditions << "LOWER(cases.status) = LOWER(:status)"
      condition_values[:status] = status
    end

    if category != ''
      conditions << "cases.category = :category"
      condition_values[:category] = category
    end

    if near != ''
      lat, lng = near.split(',')
      conditions << "(POW( ( 69.1 * ( points.longitude - :longitude ) * COS( :latitude / 57.3 ) ) , 2 ) + POW( ( 69.1 * ( points.latitude - :latitude ) ) , 2 ) ) < ( 5 * 5 )"
      condition_values[:latitude] = lat
      condition_values[:longitude] = lng
    end

    if conditions.length == 0
      @cases = Case.joins(:point, :media_url).select("cases.*, points.longitude, points.latitude, points.needs_recoding, media_urls.url").all
    else
      @cases = Case.joins(:point, :media_url).select("cases.*, points.longitude, points.latitude, points.needs_recoding, media_urls.url").where(conditions.join(' AND '), condition_values)
    end
  end
end
