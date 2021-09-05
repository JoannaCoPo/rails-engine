# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Paginator
  include Response
  include ExceptionHandler
end
