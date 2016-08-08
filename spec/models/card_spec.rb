require 'rails_helper'

describe Card do
  it "is valid with an original_text, translated_text and review_date" do
    card = Card.new(
    original_text: 'Bed',
    translated_text: 'Кровать',
    review_date: Time.now
    )
    expect(card).to be_valid
  end

  it "is invalid without a original_text" do
    card = Card.new(original_text: nil)
    card.valid?
    expect(card.errors[:original_text]).to include("can't be blank")
  end

  it "is invalid without a translated_text" do
    card = Card.new(translated_text: nil)
    card.valid?
    expect(card.errors[:translated_text]).to include("can't be blank")
  end

  it "is invalid with a duplicate word" do
    Card.create(
    original_text: "Beer", translated_text: "Пиво", review_date: Time.now)
    card = Card.new(
    original_text: "Beer", translated_text: "Пиво", review_date: Time.now)
    card.valid?
    expect(card.errors[:original_text]).to include("Данное слово уже есть в базе")
        # expect(card.errors[:translated_text]).to include("has already been taken")
  end

  it "is invalid with a matching word" do
    card = Card.create(
    original_text: "Beer", translated_text: "beer", review_date: Time.now)
    expect(card.errors[:original_text]).to include("Слова совпадают")
  end

  it "updates the review date" do
    card = Card.create(
    original_text: "Beer", translated_text: "beer", review_date: Date.today)
    card.update_date
    expect(card.review_date).to eq Date.today + 3
  end
end
