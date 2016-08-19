class Card < ActiveRecord::Base

  belongs_to :user
  belongs_to :deck

  before_save :set_review_date
  validates :original_text, :translated_text, :review_date, :user_id, :deck_id, presence: true
  validates_uniqueness_of :original_text, scope: :user_id, case_sensitive: false
  validate :validate_match

  mount_uploader :picture, PictureUploader

  # Hours between reviews
  INTERVAL_HOURS = { 0 => 0, 1 => 12.hours, 2 => 3.days, 3 => 7.days, 4 => 14.days, 5 => 30.days , 6 => 90.days }.freeze

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
    update(attempts: 3, revisions: revisions + 1)
    update(attempts: 3, revisions: 0) if revisions > 6
  end

  def decrease_count
    update(attempts: attempts - 1)
    update(attempts: 3, revisions: revisions - 1) if attempts == 0
  end

  private

  def set_review_date

    date = Date.today + case revisions
                        when 0
                          INTERVAL_HOURS[0]
                        when 1
                          INTERVAL_HOURS[1]
                        when 2
                          INTERVAL_HOURS[2]
                        when 3
                          INTERVAL_HOURS[3]
                        when 4
                          INTERVAL_HOURS[4]
                        when 5
                          INTERVAL_HOURS[5]
                        when 6
                          INTERVAL_HOURS[6]
                        end
    self.review_date = date
  end
end
