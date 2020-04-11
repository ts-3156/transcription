require 'active_support/concern'

module SessionsConcern
  extend ActiveSupport::Concern

  included do
  end

  def app_session_id
    if from_crawler?
      nil
    else
      if session[:app_session_id].blank?
        session[:app_session_id] = Digest::MD5.hexdigest("#{Time.zone.now.to_i + Time.zone.now.usec + rand(1000)}")
      end

      session[:app_session_id]
    end
  end
end