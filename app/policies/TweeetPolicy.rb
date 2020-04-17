class TweeetPolicy
  attr_reader :user, :tweeet

  def initialize(user, tweeet)
    @user = user
    @tweeet = tweeet
  end

  def update?
    tweeet.user == user
  end

  def destroy?
    tweeet.user == user
  end

end