class Post < ApplicationRecord
  belongs_to :user

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
