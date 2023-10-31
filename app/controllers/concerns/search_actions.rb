module SearchActions
  extend ActiveSupport::Concern

  def search
    @q = Post.ransack(params[:q])
    if params[:tag_name]
      @tag_name = params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").where(is_draft: false).includes(:user).order(updated_at: :desc).page(params[:page])
      return
    end 
    if !params[:q][:shikai_cont].present? && !params[:q][:bankai_cont].present? && !params[:q][:user_name_cont].present?
      redirect_to root_path
    end 
    @tag_name = ""
    @posts = @q.result(distinct: true).where(is_draft: false).includes(:user).order(updated_at: :desc).page(params[:page])
  end 

end
