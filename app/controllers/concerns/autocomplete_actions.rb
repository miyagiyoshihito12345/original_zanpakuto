module AutocompleteActions
  extend ActiveSupport::Concern

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
end 

