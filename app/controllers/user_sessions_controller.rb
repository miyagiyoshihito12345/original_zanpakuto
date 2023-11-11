class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to root_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    count = session[:count]
    shikai_count = session[:shikai_count]
    bankai_count = session[:bankai_count]
    logout
    session[:count] = count
    session[:shikai_count] = shikai_count
    session[:bankai_count] = bankai_count
    redirect_to root_path, success: t('.success')
  end
end
