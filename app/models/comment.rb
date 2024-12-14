# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  photo_id   :integer
#
class Comment < ApplicationRecord
  validates :author_id, presence: true
  validates :photo_id, presence: true
  
  belongs_to :owner, class_name: "User", foreign_key: "author_id", counter_cache: true
  has_many  :comments, dependent: :destroy
  has_many  :likes, dependent: :destroy

  has_many :commented_users, through: :comments, source: :author
  has_many :fans, through: :likes, source: :fan
end
