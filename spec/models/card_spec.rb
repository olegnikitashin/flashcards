require 'rails_helper'

describe Card do
  let!(:user) { create :user }
  let!(:deck) { create(:deck, user: user) }
  let!(:card) { create(:card, deck: deck, user: user) }
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
    expect(card.errors[:original_text]).to include(I18n.t('match'))
  end

  describe '#expired_cards' do
    it 'will send an email if unrevised cards exist' do
      ActionMailer::Base.deliveries = []
      Card.expired_cards
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end
  end

  describe '#calc' do
    it 'update efactor value' do
      expect { card.calc(5) }.to change{ card.efactor }.from(2.5).to(2.6)
    end
    it 'update repetition value' do
      expect { card.calc(5) }.to change{ card.repetition }.from(0).to(1)
    end
    it 'update review date' do
      expect { card.calc(5) }.to change{ card.review_date }.from(Date.today).to(Date.today + 1)
    end
  end
  describe '#reset_repetitions' do
    before do
      card.update_attributes(repetition: 2)
    end
    it 'update repetition value' do
      expect { card.reset_repetitions }.to change{ card.repetition }.from(2).to(0)
    end
  end
  describe '#reset_efactor' do
    before do
      card.update_attributes(efactor: 1.3)
    end
    it 'update efactor value' do
      expect { card.reset_efactor }.to change{ card.efactor }.from(1.3).to(2.5)
    end
  end
end
