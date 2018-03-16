class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # ownerships
  has_many :ownerships
  has_many :items, through: :ownerships
  # ItemFavo
  has_many :favos
  has_many :favo_items, through: :favos, class_name: 'Item', source: :item
  # ItemPlay
  has_many :plays, class_name: 'Play'
  has_many :play_items, through: :plays, class_name: 'Item', source: :item

  # relationships
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # rememberトークンをnilにする
  def forget
    update_attribute(:remember_digest, nil)
  end

                # follow関係のメソッド
  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

                # Favo関係のメソッド
  # itemをfavo
  def favo(item)
    self.favos.find_or_create_by(item_id: item.id)
  end

  # Favoの取消
  def unfavo(item)
    favo = self.favos.find_by(item_id: item.id)
    favo.destroy if favo
  end

  # Favoしているか確認
  def favo?(item)
    self.favo_items.include?(item)
  end

                # Play関係のメソッド
  # itemをplay
  def play(item)
    self.plays.find_or_create_by(item_id: item.id)
  end

  # Playの取消
  def unplay(item)
    play = self.plays.find_by(item_id: item.id)
    play.destroy if play
  end

  # Playしているか確認
  def play?(item)
    self.play_items.include?(item)
  end
end