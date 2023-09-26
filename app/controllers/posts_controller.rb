class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show search search_shikai search_bankai search_username]
  layout 'layouts/autocomplete', only: %i[ search_shikai search_bankai search_username search_tag ]

  def index
    @q = Post.ransack(params[:q])
    @posts = Post.where(is_draft: false).includes(:user).order(updated_at: :desc).page(params[:page])
  end 

  def search
    if params[:tag_name]
      @tag_name = params[:tag_name]
      @q = Post.ransack(params[:q])
      @posts = Post.tagged_with("#{params[:tag_name]}").where(is_draft: false).includes(:user).order(updated_at: :desc).page(params[:page])
      return
    end
    if !params[:q][:shikai_cont].present? && !params[:q][:bankai_cont].present? && !params[:q][:user_name_cont].present?
      redirect_to root_path
    end
    @tag_name = ""
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).where(is_draft: false).includes(:user).order(updated_at: :desc).page(params[:page])
  end
  def search_shikai
    @posts = Post.where("shikai like ?", "%#{params[:q]}%").where(is_draft: false)
  end
  def search_bankai
    @posts = Post.where("bankai like ?", "%#{params[:q]}%").where(is_draft: false)
  end
  def search_username
    @users = User.where("name like ?", "%#{params[:q]}%")
  end
  def search_tag
    if params[:q].end_with?(",")
      @tags = Tag.none
      @result = ""
      return
    end
    string = params[:q]
    elements = string.split(',')
    elements.pop
    @result = elements.join(',')
    @tags = Tag.where("name like ?", "%#{params[:q].split(',').last}%")
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
    if @post.is_draft == true
      if current_user&.id == @post.user_id
        render :show
      else
        redirect_to root_path
      end
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.is_draft == false
      if @post.update(post_params)
        redirect_to @post, success: t('defaults.message.updated', item: Post.model_name.human)
      else
        flash.now['danger'] = t('defaults.message.not_updated', item: Post.model_name.human)
        render :edit, status: :unprocessable_entity
      end
    elsif @post.is_draft == true
      if params[:commit] == t('defaults.post')
        if @post.update(post_params)
          @post.update(is_draft: false)
          redirect_to @post, success: t('defaults.message.created', item: Post.model_name.human)
        else
          flash.now['danger'] = t('defaults.message.not_created', item: Post.model_name.human)
          render :edit, status: :unprocessable_entity
        end 
      elsif params[:commit] == t('defaults.draft')
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
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to profiles_path, success: t('defaults.message.deleted')
  end

  private

  def post_params
    params.require(:post).permit(:kaigo, :kaigo_hurigana, :shikai, :shikai_hurigana, :ability, :bankai, :bankai_hurigana, :bankai_ability, :detail, :image, :image_cache, :tag_list)
  end
end
