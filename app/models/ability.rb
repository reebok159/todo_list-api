class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    return unless user.persisted?

    can :manage, Project, user_id: user.id
    can :manage, Task, project: { user_id: user.id }
    can :manage, Comment, task: { project: { user_id: user.id } }
  end
end
