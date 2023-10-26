class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def show
    @myposts = current_user.posts.where(is_draft: false).order(created_at: :desc).page(params[:page])
  end

  def my_post_order
    posts = current_user.posts.where(is_draft: false).order(created_at: :desc).page(params[:page])
    render turbo_stream: turbo_stream.replace(
      "js-my-post-order",
      partial: 'profiles/profile_order',
      locals: { posts: posts, my_post: '自分の投稿' }
    )   
  end

  def my_draft_order
    posts = current_user.posts.where(is_draft: true).order(created_at: :desc).page(params[:page])
    render turbo_stream: turbo_stream.replace(
      "js-my-post-order",
      partial: 'profiles/profile_order',
      locals: { posts: posts, my_post: '下書き' }
    )   
  end
  
  def my_reiatu_order
    posts = current_user.reiatu_posts.order(created_at: :desc).page(params[:page])
    render turbo_stream: turbo_stream.replace(
      "js-my-post-order",
      partial: 'profiles/profile_order',
      locals: { posts: posts, my_post: 'いいねした投稿' }
    )   
  end

  def edit;end

  def update
    if @user.update(user_params)
      redirect_to profiles_path, success: t('defaults.message.updated', item: User.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_updated', item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :avatar, :avatar_cache)
  end
end
