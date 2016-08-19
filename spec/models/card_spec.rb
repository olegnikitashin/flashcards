require 'rails_helper'

describe Card do
  let(:user) { create :user }
  let(:deck) { create(:deck, user: user) }
  let(:card) { create(:card, deck: deck, user: user) }
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

  describe '#increase_count' do
    it 'will increase a revisions number by 1' do
      card.update(attempts: 3, revisions: 0)
      card.increase_count
      expect(card.revisions).to eq 1
      card.update(attempts: 1, revisions: 0)
      card.increase_count
      expect(card.attempts).to eq 3
    end
  end

  describe '#decrease_count' do
    it 'will decrease an attempts number by 1' do
      card.update(attempts: 3, revisions: 0)
      card.decrease_count
      expect(card.attempts).to eq 2
      card.update(attempts: 1, revisions: 1)
      card.decrease_count
      expect(card.revisions).to eq 0
      card.update(attempts: 1, revisions: 1)
      card.decrease_count
      expect(card.attempts).to eq 3
    end
  end
  describe '#set_review_date' do
    Card::INTERVAL_HOURS.each_pair do |revisions, days|
      it 'will increase review_date according to revisions number' do
        card.update(revisions: revisions)
        expect(card.review_date).to eq Date.today + days
      end
    end
  end
end
