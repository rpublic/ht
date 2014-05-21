json.array! @cases do |c|
  json.point do
    json.latitude c.latitude
    json.longitude c.longitude
    json.needs_recoding c.needs_recoding
  end

  json.media_url do
    json.url c.url
  end unless c.url.nil?

  json.extract! c, *Case.column_names
end
