require 'active_support/concern'

module CrawlersConcern
  extend ActiveSupport::Concern

  included do
  end

  def from_crawler?
    # TODO
    false
  end

  def reject_crawler!
    head :not_found if from_crawler?
  end
end