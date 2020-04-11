require 'active_support/concern'

module GuestsConcern
  extend ActiveSupport::Concern

  included do
  end

  def create_new_guest
    Guest.create(session_id: app_session_id)
  end

  def guest_created?
    app_session_id && Guest.exists?(session_id: app_session_id)
  end

  def current_guest
    app_session_id && Guest.find_by(session_id: app_session_id)
  end
end