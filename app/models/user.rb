class User < ApplicationRecord
  has_many :dailyreports, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest



  validates :name ,presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email ,presence: true, length: {maximum: 250},
              format: {with: VALID_EMAIL_REGEX},
              uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated? (attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest,nil)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent < 2.hours.ago
  end

  def get_feed
    Dailyreport.where("user_id = ?",id)
  end

  def get_feed_yesterday
    Dailyreport.where(created_at: 1.day.ago.all_day,activated:  true)
  end

    private
    # メールアドレスをすべて小文字にする
     def downcase_email
       self.email = email.downcase
     end

     # 有効化トークンとダイジェストを作成および代入する
     def create_activation_digest
       self.activation_token  = User.new_token
       self.activation_digest = User.digest(activation_token)
     end
end
