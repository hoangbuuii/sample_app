class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum:Settings.max_length_content}
  validate :picture_size

  scope :order_by_created_at_desc, ->{order created_at: :desc}
  scope :feed, (lambda do |following_ids, id|
    where "user_id IN (?) OR user_id = ?", following_ids, id
  end)

  private

  def picture_size
    if picture.size > Settings.picture_size_mb.megabytes
      errors.add :picture, t("maxium_file_size_is_5mb")
    end
  end
end
