class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #Associations
  has_many :tweeets
  has_many :followers, class_name: "Relationship", foreign_key: 'user_id'
  has_many :following, class_name: "Relationship", foreign_key: 'follower_id'

  #Uploader
  mount_uploader :profile_pic, AvatarUploader

  def following_users
    User.where(:id => self.following.pluck(:user_id))
  end

  def follower_users
    User.where(:id => self.followers.pluck(:follower_id))
  end

  def has_liked?(tweeet)
    tweeet_id = tweeet.return_parent_or_self.id
    Like.where(:user_id => self.id, :tweeet_id => tweeet_id).first.present?
  end

  def new_retweeeted?(tweeet)
    tweeet.user_id == self.id && tweeet.parent_id.present?
  end

  def has_retweeeted_it_or_from_descendants?(tweeet)
    Tweeet.where(:parent_id => tweeet.id, :user_id => self.id).present? || (Tweeet.where(:user_id => self.id, :parent_id => tweeet.parent_id).present? && !tweeet.parent_id.blank?)
  end

end
