class Card < ActiveRecord::Base

  belongs_to :user
  belongs_to :deck

  before_save :set_review_date
  validates :original_text, :translated_text, :review_date, :user_id, :deck_id, presence: true
  validates_uniqueness_of :original_text, scope: :user_id, case_sensitive: false
  validate :validate_match


  mount_uploader :picture, PictureUploader

  # Hours between reviews
  INTERVAL_HOURS = { 0 => 0, 1 => 12.hours, 2 => 3.days, 3 => 7.days, 4 => 14.days, 5 => 30.days , 6 => 90.days, 7 => 0 }.freeze

  def self.random_card
    @random_card = Card.where('review_date <= ?', Date.today).order("RANDOM()").first
  end

  def self.expired_cards
    where('review_date <= ?', Date.today).each do |card|
      CardsMailer.pending_card_notifications(card.user.email).deliver_now
    end
  end

  def levenshtein_check(input_text)
    DamerauLevenshtein.distance(original_text.downcase.strip, input_text.downcase.strip)
  end

  def validate_match
    if original_text.downcase.strip == translated_text.downcase.strip
      errors[:original_text] = "Words match"
      errors[:translated_text] = "Words match"
    end
  end

  def increase_count
    if revisions >= 6
      update(attempts: 3, revisions: 0)
    else
      update(attempts: 3, revisions: revisions + 1)
    end
  end

  def decrease_count
    if attempts > 1
      update(attempts: attempts - 1)
    else
      update(attempts: 3, revisions: revisions - 1)
    end
  end

  private

  def set_review_date
    self.review_date = Date.today + INTERVAL_HOURS[revisions]
  end
end
