class Audio < ApplicationRecord
  belongs_to :transcript
  has_one_attached :blob
end
