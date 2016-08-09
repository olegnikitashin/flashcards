FactoryGirl.define do
  factory :card do
    original_text   "Door"
    translated_text "Дверь"
  end
  after(:create) do |card|
    card.update_attributes(review_date: Date.today.days_ago(4))
  end
end
