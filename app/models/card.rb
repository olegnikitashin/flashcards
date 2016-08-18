class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :deck

  before_save :set_review_date
  validates :original_text, :translated_text, :review_date, :user_id, :deck_id, presence: true
  validates_uniqueness_of :original_text, scope: :user_id, case_sensitive: false
  validate :validate_match

  mount_uploader :picture, PictureUploader

  def self.random_card
    @random_card = Card.where('review_date <= ?', Date.today).order("RANDOM()").first
  end

  def words_equal?(input_text)
    original_text.downcase.strip == input_text.downcase.strip
  end

  def validate_match
    if original_text.downcase.strip == translated_text.downcase.strip
      errors[:original_text] = "Words match"
      errors[:translated_text] = "Words match"
    end
  end

  def increase_count
    update(attempts: 3, revisions: revisions + 1) unless revisions > 6
    update(attempts: 3, revisions: 0) if revisions > 6
  end

  def decrease_count
      update(attempts: attempts - 1)
      update(attempts: 3, revisions: revisions - 1) if attempts == 0
  end

  private

  def set_review_date
    date = case revisions
      when 0
        Date.today
      when 1
        Date.today + 12.hours
      when 2
        Date.today + 3.days
      when 3
        Date.today + 7.days
      when 4
        Date.today + 14.days
      when 5
        Date.today + 30.days
      when 6
        Date.today + 90.days
    end
    self.review_date = date
  end
end
