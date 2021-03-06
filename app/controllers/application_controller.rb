class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # 取得情報をitem用ハッシュに保存
    def read(result)
       code = result['jan']
       name = result['title']
       url  = result['itemUrl']
       image_url = result['mediumImageUrl'].gsub('?_ex=120x120','')
  
      return {
        code: code,
        name: name,
        url: url,
        image_url: image_url,
      }
    end

    # before_action

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end