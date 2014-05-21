class MediaUrl < ActiveRecord::Base
  belongs_to :case

  def to_builder
    Jbuilder.new do |c|
      c.(self, *MediaUrl.column_names)
    end
  end
end
