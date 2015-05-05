class LikeService 

  def like(user_id, tutorial_id)
    tutorial = Tutorial.find(tutorial_id)
    like = tutorial.likes.build(user_id: user_id)
    if like.save
      Tutorial.increment_counter(:score, tutorial_id)
      return true
    else
      return false
    end
  end

end
