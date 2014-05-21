namespace 'ht' do
  desc "imports json data from specified url into tables" 
  task :import_data => :environment do
    Importer.import_data
  end

end
