class Guest < ApplicationRecord
  has_many :requests, as: :requestable

  def request_creatable?
    requests.size < self.class.files_count_limit
  end

  def files_count_limited?
    requests.size >= files_count_limit
  end

  def total_duration_limited?
    FreeTrial.duration < requests.map { |r| r.audio&.duration }.compact.sum
  end

  def files_count_limit
    self.class.files_count_limit
  end

  def expiration_limit
    self.class.expiration_limit
  end

  def remaining_files_count
    files_count_limit - requests.size
  end

  class << self
    def files_count_limit
      3
    end

    def expiration_limit
      12.hours
    end
  end
end
