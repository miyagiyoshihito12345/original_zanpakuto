class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  acts_as_taggable
  belongs_to :user

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "shikai", "bankai", "updated_at"]
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
end
