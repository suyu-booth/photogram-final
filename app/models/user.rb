# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  comments_count         :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer
#  photos_count           :integer
#  private                :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many  :photos, foreign_key: "owner_id", dependent: :destroy
  has_many  :comments, foreign_key: "author_id", dependent: :destroy
  has_many  :likes, foreign_key: "fan_id", dependent: :destroy
  has_many  :sent_follow_requests, class_name: "FollowRequest", foreign_key: "sender_id", dependent: :destroy
  has_many  :received_follow_requests, class_name: "FollowRequest", foreign_key: "recipient_id", dependent: :destroy
  has_many  :accepted_sent_follow_requests, -> { where status: "accepted" },class_name: "FollowRequest", foreign_key: "sender_id", dependent: :destroy
  has_many  :accepted_received_follow_requests, -> { where status: "accepted" }, class_name: "FollowRequest", foreign_key: "recipient_id", dependent: :destroy
  has_many  :pending_sent_follow_requests, -> { where status: "pending" },class_name: "FollowRequest", foreign_key: "sender_id", dependent: :destroy
  has_many  :pending_received_follow_requests, -> { where status: "pending" }, class_name: "FollowRequest", foreign_key: "recipient_id", dependent: :destroy

  has_many :leaders, through: :accepted_sent_follow_requests, source: :recipient
  has_many :followers, through: :accepted_received_follow_requests, source: :sender
  has_many :leaders_all_status, through: :sent_follow_requests, source: :recipient
  has_many :followers_all_status, through: :received_follow_requests, source: :sender
  has_many :leaders_pending, through: :pending_sent_follow_requests, source: :recipient
  has_many :followers_pending, through: :pending_received_follow_requests, source: :sender
  has_many :commented_photos, through: :comments, source: :photo
  has_many :liked_photos, through: :likes, source: :photo

  def self.formatted_list
    names = pluck(:username) # Plucks all product names
    case names.length
    when 0
      ""
    when 1
      names.first
    when 2
      names.join(" and ")
    else
      "#{names[0..-2].join(', ')}, and #{names.last}"
    end
  end
end
