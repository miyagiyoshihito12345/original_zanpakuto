class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @posts = Post.where(is_draft: false).includes(:user).order(created_at: :desc)
  end 

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if params[:commit] == t('defaults.post')
      if @post.save
        redirect_to root_path, success: t('defaults.message.created', item: Post.model_name.human)
      else
        flash.now['danger'] = t('defaults.message.not_created', item: Post.model_name.human)
        render :new, status: :unprocessable_entity
      end
    elsif params[:commit] == t('defaults.draft')
      @post.is_draft = true
      if @post.save
        redirect_to profiles_path, success: t('defaults.message.draft_created')
      else
        flash.now['danger'] = t('defaults.message.draft_not_created')
        render :new, status: :unprocessable_entity
      end
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:kaigo, :kaigo_hurigana, :shikai, :shikai_hurigana, :ability, :bankai, :bankai_hurigana, :bankai_ability, :detail, :image, :image_cache)
  end
end
