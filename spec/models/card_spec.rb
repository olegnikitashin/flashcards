require 'rails_helper'

describe Card do
  it "is valid with an original_text, translated_text and review_date" do
    card = Card.new(
      original_text: 'Bed',
      translated_text: 'Кровать',
      review_date: Time.now,
      user_id: '1'
      )
    expect(card).to be_valid
  end

  it "is invalid with a duplicate word" do
    Card.create(
      original_text: "Beer",
      translated_text: "Пиво",
      review_date: Time.now,
      user_id: '1'
      )
    card = Card.new(
      original_text: "Beer",
      translated_text: "Пиво",
      review_date: Time.now,
      user_id: '1'
      )
    card.valid?
    expect(card.errors[:original_text]).to include("Данное слово уже есть в базе")
  end

  it "is invalid with a matching word" do
    card = Card.create(
      original_text: "Beer",
      translated_text: "beer",
      review_date: Time.now,
      user_id: '1'
      )
    expect(card.errors[:original_text]).to include("Слова совпадают")
  end

  it "updates the review date" do
    card = Card.create(
      original_text: "Beer",
      translated_text: "beer",
      review_date: Date.today,
      user_id: '1'
      )
    card.update_date
    expect(card.review_date).to eq Date.today + 3
  end
end
