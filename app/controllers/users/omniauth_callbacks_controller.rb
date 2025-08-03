# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authorization
  end

  def google_oauth2
    authorization
  end
  
  private
  def authorization
    # Userモデルから返ってきた値を@sns_infoに代入
    @sns_info = User.from_omniauth(request.env["omniauth.auth"])
    # @userには「nickname」と「email」の情報を保持させる
    @user = @sns_info[:user]

    if @user.persisted? #ユーザー情報が登録済みなので、新規登録ではなくログイン処理を行う
      sign_in_and_redirect @user, event: :authentication
    else #ユーザー情報が未登録なので、新規登録画面へ遷移する
      @sns_id = @sns_info[:sns].id # SNS認証の判断は、idのみで行う
      render template: 'devise/registrations/new'
    end
  end
end