class Message < ApplicationRecord
  has_many_attached :attachments, dependent: :destroy

  default_scope { order(created_at: :desc) }
  scope :visible, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }
end
