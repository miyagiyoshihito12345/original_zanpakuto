module SearchActions
  extend ActiveSupport::Concern

  def search
    @q = Post.ransack(params[:q])
    if params[:tag_name]
      @tag_name = params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").where(is_draft: false).includes(:user).order(updated_at: :desc).page(params[:page])
      return
    end 
    if !params[:q][:kaigo_or_shikai_or_bankai_cont].present? && !params[:q][:user_name_cont].present? && !params[:q][:id_not_eq].present?
      redirect_to root_path
    end 
    @tag_name = ""
    if params[:q][:id_not_eq].present?
      @posts = @q.result(distinct: true).tagged_with("#{params[:q][:id_not_eq]}").where(is_draft: false).includes(:user).order(updated_at: :desc).page(params[:page])
    else
      @posts = @q.result(distinct: true).where(is_draft: false).includes(:user).order(updated_at: :desc).page(params[:page])
    end
  end 

end
