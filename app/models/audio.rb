class Audio < ApplicationRecord
  belongs_to :request
  has_one_attached :blob
end
