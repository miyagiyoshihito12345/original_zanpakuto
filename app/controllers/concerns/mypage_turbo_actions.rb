module MypageTurboActions
  extend ActiveSupport::Concern

  def my_post_order
    posts = current_user.posts.where(is_draft: false).order(created_at: :desc).page(params[:page])
    turbo(posts, "自分の投稿")
  end 

  def my_draft_order
    posts = current_user.posts.where(is_draft: true).order(created_at: :desc).page(params[:page])
    turbo(posts, "下書き")
  end 

  def my_reiatu_order
    posts = current_user.reiatu_posts.order(created_at: :desc).page(params[:page])
    turbo(posts, "いいねした投稿")
  end 

  private

  def turbo(posts, my_post)
    render turbo_stream: turbo_stream.replace(
      "js-my-post-order",
      partial: 'profiles/profile_order',
      locals: { posts: posts, my_post: my_post }
    )   
  end
end 
