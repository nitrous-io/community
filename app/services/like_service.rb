class LikeService 

  def like(user_id, post_id)
    tutorial = Post.find(post_id)
    like = tutorial.likes.build(user_id: user_id)
    if like.save
      Post.increment_counter(:score, post_id)
      return true
    else
      return false
    end
  end

end
