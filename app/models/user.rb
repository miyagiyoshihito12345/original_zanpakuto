class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts, dependent: :destroy
  has_many :reiatus, dependent: :destroy 
  has_many :reiatu_posts, through: :reiatus, source: :post
  has_many :authentications, dependent: :destroy

  accepts_nested_attributes_for :authentications

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  mount_uploader :avatar, AvatarUploader
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :name, presence: true, length: { maximum: 255 }

  def own?(object)
    id == object.user_id
  end 

  def reiatu(post)
      reiatu_posts << post
  end

  def unreiatu(post)
      reiatu_posts.destroy(post)
  end

  def reiatu?(post)
      reiatu_posts.include?(post)
  end
end
