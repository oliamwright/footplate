class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      can :manage, User, id: user.id
      can :manage, Feed, user_id: user.id
      can :manage, FeedEntry, feed: { user_id: user.id }
      can :manage, Scheduler, user_id: user.id
    end
  end
end
