class ReiatusController < ApplicationController
skip_before_action :require_login, only: %i[ create ]
  def create
    post = Post.find(params[:post_id])
    current_user.reiatu(post)
    render turbo_stream: turbo_stream.replace(
      "entry-reiatus-#{post.id}",
      partial: 'posts/unreiatu',
      locals: { post: post }
    )
  end

  def destroy
    post = current_user.reiatus.find(params[:id]).post
    current_user.unreiatu(post)
    render turbo_stream: turbo_stream.replace(
      "entry-unreiatus-#{post.id}",
      partial: 'posts/reiatu',
      locals: { post: post }
    )
  end

  def before_login
     redirect_to login_path, warning: t('defaults.message.require_login')
  end
end
