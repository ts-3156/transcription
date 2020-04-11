class ApplicationController < ActionController::Base
  include CrawlersConcern
  include SessionsConcern
  include GuestsConcern
end
