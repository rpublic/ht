class Point < ActiveRecord::Base
  belongs_to :case

  def to_builder
    Jbuilder.new do |c|
      c.(self, *Point.column_names)
    end
  end
end
