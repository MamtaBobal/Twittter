class Tweeet < ApplicationRecord

  #Associations
  belongs_to :user
  has_many :likes
  has_many :retweeets, class_name: 'Tweeet', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: 'Tweeet', optional: true

  def get_retweeets_of_a_tweeet
    retweets
  end

  def get_parent_of_a_tweeet
    parent
  end

  def is_retweeeted?
    parent.present?
  end

  def return_parent_or_self
    if parent.blank?
      self
    else
      parent
    end
  end

  def tweeet_likes
    return_parent_or_self.likes
  end

  def tweeet_retweeets
    return_parent_or_self.retweeets
  end

end
