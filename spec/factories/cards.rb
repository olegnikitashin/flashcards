FactoryGirl.define do
  factory :card do
    original_text   'Door'
    translated_text 'Дверь'
    attempts 3
    revisions 0
    review_date Date.today
    user
    deck
  end
end
