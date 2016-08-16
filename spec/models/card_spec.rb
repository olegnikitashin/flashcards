require 'rails_helper'

describe Card do
  let!(:user) { create :user }
  let!(:deck) { create(:deck, user: user)}
  it "is valid with an original_text, translated_text and review_date" do
    card = Card.new(
      original_text: 'Bed',
      translated_text: 'Кровать',
      review_date: Time.now,
      user: user,
      deck: deck
    )
    expect(card).to be_valid
  end

  it "is invalid with a duplicate word" do
    Card.create(
      original_text: "Beer",
      translated_text: "Пиво",
      review_date: Time.now,
      user: user,
      deck: deck
    )
    card = Card.new(
      original_text: "Beer",
      translated_text: "Пиво",
      review_date: Time.now,
      user: user,
      deck: deck
    )
    card.valid?
    expect(card.errors[:original_text]).to include("has already been taken")
  end

  it "is invalid with a matching word" do
    card = Card.create(
      original_text: "Beer",
      translated_text: "beer",
      review_date: Time.now,
      user: user,
      deck: deck
    )
    expect(card.errors[:original_text]).to include("Words match")
  end

  it "updates the review date" do
    card = Card.create(
      original_text: "Beer",
      translated_text: "beer",
      review_date: Date.today,
      user: user,
      deck: deck
    )
    card.update_date
    expect(card.review_date).to eq Date.today + 3
  end
end
