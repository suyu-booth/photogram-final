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
  
  validates :photo_id, presence: true
  validates :author_id, presence: true

  belongs_to :author, class_name: "User", counter_cache: true
  belongs_to :photo, counter_cache: true
end
