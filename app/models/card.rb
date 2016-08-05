class Card < ActiveRecord::Base
  validates :original_text, :translated_text, :review_date, presence: true
  validates :original_text, uniqueness: { message: "Данное слово уже есть в базе" }
  validate :validate_match

  before_create do
    self.review_date = 3.days.from_now
  end

  def self.random_card
    @random_card = Card.where('review_date <= ?', Date.today).order("RANDOM()").first
  end

  def words_equal?(input_text)
    original_text.downcase.strip == input_text.downcase.strip
  end

  def update_date
    update(review_date: 3.days.from_now)
  end

  def validate_match
    if original_text.downcase.strip == translated_text.downcase.strip
      errors[:original_text] = "Слова совпадают"
      errors[:translated_text] = "Слова совпадают"
    end
  end
end
