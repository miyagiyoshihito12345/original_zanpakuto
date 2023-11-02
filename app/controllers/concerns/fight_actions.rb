module FightActions
  extend ActiveSupport::Concern

  def fight_select
    @post = Post.where(is_draft: false).find(params[:id])
    @posts = Post.where("id != ? AND is_draft = ?", params[:id], false).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def fight
    @my_post = Post.where(is_draft: false).find(params[:my_post_id])
    @post = Post.where(is_draft: false).find(params[:post_id])
    @winning_rate = @my_post.winning_rate(@post)
    # true対false が n対100-n になる配列を生成して、ランダムに1つ選択
    @win = ([true] * @winning_rate + [false] * (100 - @winning_rate)).sample
    @meigen = t("defaults.meigen.#{rand(1..28)}")
  end

  def fight_detail
    post = Post.where(is_draft: false).find(params[:id])
    render turbo_stream: turbo_stream.replace(
      'modal',
      partial: 'posts/fight_detail',
      locals: { post: post }
    )
  end

  def fight_close
    render turbo_stream: turbo_stream.replace(
      'fight-detail-modal',
      partial: 'posts/fight_modal'
    )
  end
end
