class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :requests, as: :requestable

  before_validation do
    if phone.present?
      phone.tr!('０-９-ー', '0-9--')
      phone.remove!('-')
    end
  end

  EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, {presence: true, format: {with: EMAIL_REGEXP}, uniqueness: {case_sensitive: false}}

  PHONE_REGEXP = /\A0\d{9,10}\z/i
  validates :phone, {presence: true, format: {with: PHONE_REGEXP}, uniqueness: {case_sensitive: false}}

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

  def paid?
    # TODO
    false
  end

  def files_count_limited?
    !paid? && requests.size >= files_count_limit
  end

  def total_duration_limited?
    !paid? && FreeTrial.total_duration < requests.map { |r| r.audio&.duration }.compact.sum
  end

  def files_count_limit
    self.class.files_count_limit(paid?)
  end

  def expiration_limit
    self.class.expiration_limit(paid?)
  end

  def remaining_files_count
    files_count_limit - requests.size
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
