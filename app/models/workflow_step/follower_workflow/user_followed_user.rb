class WorkflowStep::FollowerWorkflow::UserFollowedUser < WorkflowStep::FollowerWorkflow::BaseStep
  def lister
    @followed
  end

  def data
    {
      user: @user,
      follower_user: @user,
      followed_user: @followed
    }
  end
end
