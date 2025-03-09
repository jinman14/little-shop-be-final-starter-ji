FactoryBot.define do
  factory :coupon do
    name { "Coo-pin Time" }
    code { "#{SecureRandom.hex(4)}" }
    discount { 10.0 }
    association :merchant
    status { "active" }
  end
end