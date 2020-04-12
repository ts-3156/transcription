class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :requests, as: :requestable

  def paid?
    # TODO
    false
  end

  # TODO Deprecated
  def request_creatable?
    requests.size < self.class.files_count_limit(paid?)
  end

  def files_count_limited?
    !paid? && requests.size >= files_count_limit
  end

  def total_duration_limited?
    !paid? && FreeTrial.duration < requests.map { |r| r.audio&.duration }.compact.sum
  end

  def files_count_limit
    self.class.files_count_limit(paid?)
  end

  def expiration_limit
    self.class.expiration_limit(paid?)
  end

  def remaining_files_count
    file_count_limit - requests.size
  end

  class << self
    def files_count_limit(paid)
      paid ? 1000 : 10
    end

    def expiration_limit(paid)
      paid ? 1.year : 30.days
    end
  end
end
