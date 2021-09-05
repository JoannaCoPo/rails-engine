class ApplicationController < ActionController::API
  include Paginator
  include Response
  include ExceptionHandler
end
