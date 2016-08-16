class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck

  before_create :set_review_date
  validates :original_text, :translated_text, :user_id, :deck_id, presence: true
  validates_uniqueness_of :original_text, scope: :user_id, case_sensitive: false
  validate :validate_match

  mount_uploader :picture, PictureUploader

  def self.random_card
    @random_card = Card.where('review_date <= ?', Date.today).order("RANDOM()").first
  end

  def words_equal?(input_text)
    original_text.downcase.strip == input_text.downcase.strip
  end

  def update_date
    update(review_date: Date.today + 3)
  end

  def validate_match
    if original_text.downcase.strip == translated_text.downcase.strip
      errors[:original_text] = "Words match"
      errors[:translated_text] = "Words match"
    end
  end

  private

  def set_review_date
    self.review_date = Date.today + 3
  end
end
