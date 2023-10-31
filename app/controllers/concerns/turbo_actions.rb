module TurboActions
  extend ActiveSupport::Concern
  def index_new_order
    posts= Post.where(is_draft: false).includes(:user).order(created_at: :desc).page(params[:page])
    turbo(posts)
  end 

  def index_edit_order
    posts= Post.where(is_draft: false).includes(:user).order(updated_at: :desc).page(params[:page])
    turbo(posts)
  end 

  def index_reiatu_order
    posts = Post.where(is_draft: false).includes(:user).left_joins(:reiatus).group(:id).order('COUNT(reiatus.id) DESC').page(params[:page])
    turbo(posts)
  end 

  private

  def turbo(posts)
    render turbo_stream: turbo_stream.replace(
      "js-index-order",
      partial: 'posts/index_order',
      locals: { posts: posts }
    )   
  end 
end 

