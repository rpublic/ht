class Case < ActiveRecord::Base
  validates :case_id, uniqueness: true

  self.primary_key = 'case_id'

  has_one :point
  has_one :media_url

  def to_builder
    Jbuilder.new do |c|
      c.(self, *Case.column_names)
    end
  end
end
