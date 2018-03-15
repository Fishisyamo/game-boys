class Item < ApplicationRecord
  validates :code, presence: true, length: { maximum: 255 }
  validates :name, presence: true, length: { maximum: 255 }
  validates :url, presence: true, length: { maximum: 255 }
  validates :image_url, presence: true, length: { maximum: 255 }
  
  # ownerships
  has_many :ownerships
  has_many :users, through: :ownerships
  # favousewrs
  has_many :favos
  has_many :favo_users, through: :favos, class_name: 'User', source: :user
  # Playusers
  has_many :plays, class_name: 'Play'
  has_many :play_users, through: :plays, class_name: 'User', source: :user
end