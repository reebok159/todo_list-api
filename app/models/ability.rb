class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.present?
      can :manage, Task, user_id: user.user_id
      can :manage, Project, list: { user_id: user.id }
    end
  end
end
