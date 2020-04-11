class Request < ApplicationRecord
  has_one :audio
  has_one :transcript

  validates :name, presence: true, length: {maximum: 50}
end
