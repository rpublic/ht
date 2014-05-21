require 'spec_helper'
require 'rake'
require 'json'

describe "ht namespace rake task" do
  before :all do
    Rake.application.rake_require "tasks/ht"
    Rake::Task.define_task(:environment)
  end

  describe 'ht:import' do
    before do
      JSON.stub(:parse) {
        [{
          "point" => {
            "needs_recoding" => false,
            "longitude" => "-122.420210581031",
            "latitude" => "37.788222551169"
          },
          "category" => "Street and Sidewalk Cleaning",
          "request_details" => "Refrigerator_w_doors",
          "source" => "Integrated Agency",
          "address" => "Intersection of FERN ST and POLK ST",
          "request_type" => "Illegal_Dumping",
          "status" => "Open",
          "updated" => "2014-05-20T21:32:03",
          "neighborhood" => "Downtown/Civic Center",
          "case_id" => "3662264",
          "supervisor_district" => "3",
          "responsible_agency" => "Recology_Abandoned",
          "opened" => "2014-05-20T21:32:03",
          "media_url" => {
          "url" => "http://mobile311.sfgov.org/media/san_francisco/report/photos/537c2609df8681a99365df0e/photo_20140520_210541.jpg"
          }
        }]        
      }
    end

    let :run_rake_task do
      Rake::Task["ht:import_data"].reenable
      Rake.application.invoke_task "ht:import_data"
    end

    it "should import data into the db" do
      run_rake_task

      c = Case.all
      point = Point.all
      url = MediaUrl.all

      expect(c.length).to eq 1
      expect(c[0].case_id.to_i).to eq 3662264

      expect(point.length).to eq 1
      expect(point[0].case_id.to_i).to eq 3662264

      expect(url.length).to eq 1
      expect(url[0].case_id.to_i).to eq 3662264
    end

  end

end
