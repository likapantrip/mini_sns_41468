class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def configure_permitted_parameters
    # ニックネーム、苗字、名前、誕生日カラムの値を送信できるようにする
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :lastname, :firstname, :birthday])
  end
end
