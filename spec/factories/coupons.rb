FactoryBot.define do
  factory :coupon do
    name { Faker::Name.name }
    code { "#{SecureRandom.hex(4)}" }
    discount { 10.0 }
    association :merchant
    status { "active" }
  end
end