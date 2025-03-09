FactoryBot.define do
  factory :coupon do
    name { "Coo-pin Time" }
    code { "disCoo" }
    discount { 10.0 }
    association :merchant
    status { "active" }
  end
end