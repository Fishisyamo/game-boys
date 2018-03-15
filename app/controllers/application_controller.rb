class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    # 取得情報をitem用ハッシュに保存
    def read(result)
       code = result['makerCode']
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
end