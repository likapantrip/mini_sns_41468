class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, # Omniauthによる認証ができるようにする
         omniauth_providers: [:facebook, :google_oauth2] # FacebookとGoogleのOmniAuthを使用できる
         
  has_many :sns_credentials

  def self.from_omniauth(auth)
    # SNS認証を行ったことがあるかを判断し、存在しない場合はデータベースに保存
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    # SNS認証したことがあればアソシエーションで取得し、無ければemailでユーザー検索して取得orビルド(保存はしない)
    user = User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
      email: auth.info.email
    )
    # userが登録済みであるか判断
    if user.persisted?
      sns.user = user # SnsCredentialモデルとUserモデルを紐づける
      sns.save
    end
    { user: user, sns: sns } # snsに入っているsns_idをビューで扱えるようにするため、コントローラーに渡す
  end
end