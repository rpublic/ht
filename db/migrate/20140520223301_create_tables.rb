class CreateTables < ActiveRecord::Migration
  def change
  
=begin
{
  "point" : {
    "needs_recoding" : false,
    "longitude" : "-122.410345961",
    "latitude" : "37.773101757"
  },
  "category" : "Street and Sidewalk Cleaning",
  "request_details" : "Garbage",
  "request_type" : "Transit_Shelter_Platform",
  "status" : "Closed",
  "updated" : "2014-05-18T07:38:07",
  "media_url" : {
    "url" : "http://mobile311.sfgov.org/media/san_francisco/report/photos/537824a3df8681a99365c5e0/1400382285064.jpg"
  },
  "neighborhood" : "South of Market",
  "case_id" : "3652897",
  "closed" : "2014-05-18T07:38:07",
  "supervisor_district" : "6",
  "responsible_agency" : "Clear Channel - Transit Queue",
  "opened" : "2014-05-17T20:10:36"
}
=end

    create_table :cases, :id => false, :force => true do |t|
      t.string :category 
      t.string :request_details 
      t.string :request_type 
      t.string :status 
      t.datetime :updated 
      t.string :neighborhood 
      t.integer :case_id, :unique => true, :null => false 
      t.datetime :closed 
      t.integer :supervisor_district 
      t.string :responsible_agency 
      t.datetime :opened 
    end

    create_table :media_urls, :id => false, :force => true do |t|
      t.integer :case_id
      t.string :url
    end

    create_table :points, :id => false, :force => true do |t|
      t.integer :case_id
      t.boolean :needs_recoding
      t.decimal :longitude, {:precision => 15, :scale => 12}
      t.decimal :latitude, {:precision => 15, :scale => 12}
    end
  end
end
