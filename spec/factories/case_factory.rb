FactoryGirl.define do
  factory :point do
  end

  factory :media_url do
  end

  factory :case do
    case_id { rand(1000000000) }
  end
end
