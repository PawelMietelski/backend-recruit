class Message < ApplicationRecord
  scope :visible, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }
end
