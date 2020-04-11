class Request < ApplicationRecord
  belongs_to :requestable, polymorphic: true, optional: true
  has_one :audio
  has_one :transcript

  validates :name, presence: true, length: {maximum: 50}
end
