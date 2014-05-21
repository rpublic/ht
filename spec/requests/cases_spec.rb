require 'spec_helper'
require 'database_cleaner'

describe "Cases API" do
  describe "GET /cases.json" do
    it "should eturns all cases" do
      c = FactoryGirl.create(:case)
      FactoryGirl.create(:point, 'case' => c)
      FactoryGirl.create(:media_url, 'case' => c)

      get "/cases.json", {}, { "Accept" => "application/json" }
      
      expect(response.status).to eq 200

      body = JSON.parse(response.body)
      expect(body.length).to eq 1
    end
  end

  describe "GET /cases.json?since=1398465719" do
    it "it should return cases opened since UNIX timestamp 1398465719" do
      case_params = { 'since' => 1398465719 }
      time = Time.at(case_params['since'])
  
      c = FactoryGirl.create(:case, { 'opened' => time.utc.to_s })
      FactoryGirl.create(:point, 'case' => c)
      FactoryGirl.create(:media_url, 'case' => c)

      request_headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      get "/cases.json", case_params, request_headers

      expect(response.status).to eq 200

      body = JSON.parse(response.body)
      since = body.map { |m| m['opened'] }
      expect(since).to match_array([ "2014-04-25T22:41:59.000Z" ])
    end
  end

  describe "GET /cases.json?status=open" do
    it "it should return cases that are in open state." do
      case_params = { 'status' => 'open' }
 
      c = FactoryGirl.create(:case, case_params)
      FactoryGirl.create(:point, 'case' => c)
      FactoryGirl.create(:media_url, 'case' => c)

      request_headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      get "/cases.json", case_params, request_headers

      expect(response.status).to eq 200

      body = JSON.parse(response.body)
      status = body.map { |m| m['status'] }
      expect(status).to match_array([ "open" ])
    end
  end

  describe "GET /cases.json?category=General%20Requests" do
    it "it should return cases that belong to 'General Requests' category" do
      case_params = { 'category' => 'General Requests' }

      c = FactoryGirl.create(:case, case_params)
      FactoryGirl.create(:point, 'case' => c)
      FactoryGirl.create(:media_url, 'case' => c)

      request_headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      get "/cases.json", case_params, request_headers

      expect(response.status).to eq 200

      body = JSON.parse(response.body)
      categories = body.map { |m| m['category'] }
      expect(categories).to match_array([ "General Requests" ])    
    end
  end

  describe "GET /cases.json?near=37.77,-122.48" do
    it "should return cases that were created within 5 mile radius of lat=37.77 and lng=-122.48" do
      case_params = { 'near' => '37.77,-122.48' }
      lat, lng = case_params['near'].split(',')

      c = FactoryGirl.create(:case)
      FactoryGirl.create(:point, 'case' => c, 'latitude' => lat, 'longitude' => lng)
      FactoryGirl.create(:media_url, 'case' => c)

      request_headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      get "/cases.json", case_params, request_headers

      expect(response.status).to eq 200

      body = JSON.parse(response.body)

      point = body.map { |m| m['point'] }.first
      expect(point).to eq( {"latitude"=>"37.77", "longitude"=>"-122.48", "needs_recoding"=>nil} )
    end
  end

  describe "GET /cases.json?near=37.77,-122.48&status=open&category=General%20Requests" do
    it "API endpoint should be able to take any combination of GET params." do
      point_params = { 'near' => '37.77,-122.48', }
      case_params = {'status' => 'open', 'category' => 'General Requests' }
      lat, lng = point_params['near'].split(',')

      c = FactoryGirl.create(:case, case_params)
      FactoryGirl.create(:point, 'case' => c, 'latitude' => lat, 'longitude' => lng)
      FactoryGirl.create(:media_url, 'case' => c)
    
      request_headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      get "/cases.json", case_params.merge(point_params), request_headers

      expect(response.status).to eq 200

      body = JSON.parse(response.body)

      point = body.map { |m| m['point'] }.first
      status = body.map { |m| m['status'] }
      category = body.map { |m| m['category'] }

      expect(point).to eq( {"latitude"=>"37.77", "longitude"=>"-122.48", "needs_recoding"=>nil} )
      expect(status).to match_array( ['open'] )
      expect(category).to match_array( ['General Requests'] )
    end
  end
end
