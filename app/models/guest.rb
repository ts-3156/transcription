class Guest < ApplicationRecord
  has_many :requests, as: :requestable

  validate do
    if files_count_limited?
      errors.add(:base, I18n.t('activerecord.errors.messages.files_count_limited'))
    end
  end

  validate do
    if total_duration_limited?
      errors.add(:base, I18n.t('activerecord.errors.messages.total_duration_limited'))
    end
  end

  def files_count_limited?
    requests.size >= files_count_limit
  end

  def total_duration_limited?
    FreeTrial.total_duration < requests.map { |r| r.audio&.duration }.compact.sum
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
