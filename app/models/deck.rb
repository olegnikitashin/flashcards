class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards, dependent: :destroy

  validates :current, uniqueness: { scope: :user_id }, if: -> { current == true }
  validates :title, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }

  def self.find_current_deck
    find_by(current: true)
  end

  def make_current
    Deck.where(current: true, user: user).update_all(current: false)
    update(current: !current)
  end
end
