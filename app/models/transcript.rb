class Transcript < ApplicationRecord
  has_one :audio

  validates :name, presence: true, length: {maximum: 200}
end
