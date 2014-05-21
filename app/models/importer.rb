require 'open-uri'
require 'json'

class Importer
  URI = "http://data.sfgov.org/resource/vw6y-z8j6.json"

  def self.import_data
    results = JSON.parse(open(URI).read)
    existing_case_ids = {}
    Case.select('case_id').all.map { |c| existing_case_ids[c.case_id] = true }

    results.each do |result|
      next if result.length == 0 || existing_case_ids[result['case_id'].to_i] || false

      c = Case.create({
        :category => result['category'],
        :request_details => result['request_details'],
        :request_type => result['request_type'],
        :status => result['status'],
        :updated => Time.parse(result['updated']).utc.to_s,
        :neighborhood => result['neighborhood'],
        :case_id => result['case_id'],
        :closed => result['closed'].nil? ? nil : Time.parse(result['closed']).utc.to_s,
        :supervisor_district => result['supervisor_district'],
        :responsible_agency => result['responsible_agency'],
        :opened => Time.parse(result['opened']).utc.to_s
      })

      result_point = result['point']

      Point.create({ 
        :needs_recoding => result_point['needs_recoding'], 
        :longitude => result_point['longitude'], 
        :latitude => result_point['latitude'],
        :case_id => c.case_id
      })

      MediaUrl.create({ 
        :url => result['url'], 
        :case_id => c.case_id
      })
    end
  end
end
