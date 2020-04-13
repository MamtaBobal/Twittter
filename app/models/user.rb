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

end
