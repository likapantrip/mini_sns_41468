class SnsCredential < ApplicationRecord
  belongs_to :user, optional: true # 外部キーの値がない場合でも保存ができる
end
