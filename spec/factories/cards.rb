FactoryGirl.define do
  factory :card do
    original_text   'Door'
    translated_text 'Дверь'
    review_date Date.today
    user
    deck
  end
end
