class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @posts = Post.all.includes(:user).order(created_at: :desc)
  end 

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to '/#post', success: t('defaults.message.created', item: Post.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_created', item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def post_params
    params.require(:post).permit(:kaigo, :kaigo_hurigana, :shikai, :shikai_hurigana, :ability, :bankai, :bankai_hurigana, :bankai_ability, :detail, :image, :image_cache)
  end
end
