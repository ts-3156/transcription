class Request < ApplicationRecord
  belongs_to :requestable, polymorphic: true, optional: true
  has_one :audio
  has_one :transcript

  # validates :name, presence: true, length: {maximum: 50}

  def user_or_guest
    if requestable_type && requestable_id
      @user_or_guest ||= requestable_type.constantize.find_by(id: requestable_id)
    end
  end

  def expired?
    persisted? && created_at <= user_or_guest.expiration_limit
  end

  def paid?
    # TODO
    false
  end
end
