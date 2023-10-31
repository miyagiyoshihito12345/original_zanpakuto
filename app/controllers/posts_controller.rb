class PostsController < ApplicationController
  include SearchActions
  include AutocompleteActions
  include TurboActions

  skip_before_action :require_login, only: %i[index show search search_shikai search_bankai search_username index_new_order index_edit_order index_reiatu_order]
  before_action :set_post, only: %i[edit update destroy]
  layout 'layouts/autocomplete', only: %i[ search_shikai search_bankai search_username search_tag ]

  def index
    @q = Post.ransack(params[:q])
    @posts = Post.where(is_draft: false).includes(:user).order(created_at: :desc).page(params[:page])
  end 

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if press?(t('defaults.ai_post'))
      @post.tag_list = @post.tag_list.first.split(" ") 
      if @post.save
        redirect_to root_path, success: t('defaults.message.created', item: Post.model_name.human)
      end
    end
    if press?(t('defaults.post'))
      if @post.save
        redirect_to root_path, success: t('defaults.message.created', item: Post.model_name.human)
      else
        flash.now['danger'] = t('defaults.message.not_created', item: Post.model_name.human)
        render :new, status: :unprocessable_entity
      end
    elsif press?(t('defaults.draft'))
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
    if @post.is_draft
      if current_user&.own?(@post)
        render :show
      else
        redirect_to root_path
      end
    end
  end

  def edit
  end

  def update
    if !@post.is_draft
      if @post.update(post_params)
        redirect_to @post, success: t('defaults.message.updated', item: Post.model_name.human)
      else
        flash.now['danger'] = t('defaults.message.not_updated', item: Post.model_name.human)
        render :edit, status: :unprocessable_entity
      end
    elsif @post.is_draft
      if press?(t('defaults.post'))
        if @post.update(post_params)
          @post.update(is_draft: false)
          redirect_to @post, success: t('defaults.message.created', item: Post.model_name.human)
        else
          flash.now['danger'] = t('defaults.message.not_created', item: Post.model_name.human)
          render :edit, status: :unprocessable_entity
        end 
      elsif press?(t('defaults.draft'))
        if @post.update(post_params)
          redirect_to profiles_path, success: t('defaults.message.draft_updated')
        else
          flash.now['danger'] = t('defaults.message.draft_not_updated')
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @post.destroy!
    redirect_to profiles_path, success: t('defaults.message.deleted')
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:kaigo, :kaigo_hurigana, :shikai, :shikai_hurigana, :ability, :bankai, :bankai_hurigana, :bankai_ability, :detail, :image, :image_cache, :tag_list)
  end

  def press?(button_name)
    params[:commit] == button_name
  end
end
