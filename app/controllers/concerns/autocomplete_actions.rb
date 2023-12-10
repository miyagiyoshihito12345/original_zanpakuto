module AutocompleteActions
  extend ActiveSupport::Concern

  def search_kaigo_shikai_bankai
    @posts_kaigo = Post.where("kaigo like ?", "%#{params[:q]}%").where(is_draft: false).select(:kaigo).distinct
    @posts_shikai = Post.where("shikai like ?", "%#{params[:q]}%").where(is_draft: false).select(:shikai).distinct
    @posts_bankai = Post.where("bankai like ?", "%#{params[:q]}%").where(is_draft: false).select(:bankai).distinct
  end 

  def search_username
    #一件以上投稿しているユーザーを取得
    @users = User.joins(:posts).where("users.name LIKE ?", "%#{params[:q]}%").group("users.id")
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
end 

