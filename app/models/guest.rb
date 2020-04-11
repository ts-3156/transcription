class Guest < ApplicationRecord
  has_many :requests, as: :requestable
end
