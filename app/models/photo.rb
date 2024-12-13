# == Schema Information
#
# Table name: photos
#
#  id             :bigint           not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord
  
  validates :owner_id, presence: true

  belongs_to :owner, class_name: "User", counter_cache: true
  has_many  :comments, dependent: :destroy
  has_many  :likes, dependent: :destroy

  has_many :commented_users, through: :comments, source: :author
  has_many :fans, through: :likes, source: :fan

  mount_uploader :image, ImageUploader
end
