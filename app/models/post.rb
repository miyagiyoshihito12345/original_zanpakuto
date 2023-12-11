class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  acts_as_taggable
  belongs_to :user
  has_many :reiatus, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "kaigo", "shikai", "bankai", "detail", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  validates :kaigo, length: { maximum: 255 }
  validates :kaigo_hurigana, length: { maximum: 255 }
  validates :shikai, presence: true, length: { maximum: 255 }
  validates :shikai_hurigana, length: { maximum: 255 }
  validates :ability, presence: true, length: { maximum: 65_535 }
  validates :bankai, length: { maximum: 255 }
  validates :bankai_hurigana, length: { maximum: 255 }
  validates :bankai_ability, length: { maximum: 65_535 }
  validates :detail, length: { maximum: 65_535 }

  def previous
    Post.where("id < ?", self.id).where(is_draft: false).order("id DESC").first
  end

  def next
    Post.where("id > ?", self.id).where(is_draft: false).order("id ASC").first
  end

  def power
    power = self.ability.size
    power += self.bankai_ability.size    unless self.bankai_ability.nil?
    power += self.detail.size            unless self.detail.nil?
    power += 30                          unless self.image.file.nil?
    power
  end 

  def winning_rate(post)
    rate = self.power * 100 / (self.power + post.power)

    rate += 10 if rate <= 39
    rate -= 10 if rate >= 61
    #10%の確率で超最強チート系になる
    rate = 99 if rand(1..100) <= 10

    rate
  end
end
