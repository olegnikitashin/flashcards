class Card < ActiveRecord::Base

  belongs_to :user
  belongs_to :deck

  before_create :set_review_date
  validates :original_text, :translated_text, :review_date, :user_id, :deck_id, presence: true
  validates_uniqueness_of :original_text, scope: :user_id, case_sensitive: false
  validate :validate_match
  scope :expired, -> { where('review_date <= ?', Date.today) }

  mount_uploader :picture, PictureUploader

  def self.random_card
    @random_card = Card.where('review_date <= ?', Date.today).order("RANDOM()").first
  end

  def calc(review_seconds)
    calculation = Supermemo.construct(review_seconds, efactor, repetition)
    update(calculation)
  end

  def self.expired_cards
    User.joins(:cards).merge(Card.expired).uniq.each do |user|
      CardsMailer.pending_card_notifications(user).deliver_now
    end
  end

  def levenshtein_check(input_text)
    DamerauLevenshtein.distance(original_text.downcase.strip, input_text.downcase.strip)
  end

  def validate_match
    if original_text.downcase.strip == translated_text.downcase.strip
      errors[:original_text] = I18n.t('match')
      errors[:translated_text] = I18n.t('match')
    end
  end

  private

  def set_review_date
    self.review_date = Date.today
  end
end
