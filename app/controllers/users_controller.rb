class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :user_find,      only: [:show, :edit, :update,
                                        :following, :followers]
  before_action :counts,    only: [:show, :following, :followers]

  def show
    @items = @user.items.uniq
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'ユーザーを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました。'
      render :new
    end
  end

  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを編集しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email,
                                   :password, :password_confirmation)
    end

    def user_find
      @user  = User.find(params[:id])
    end

    def counts
      @count_favo = @user.favo_items.count
      @count_play = @user.play_items.count
      @count_following = @user.following.count
      @count_followers = @user.followers.count
    end

end