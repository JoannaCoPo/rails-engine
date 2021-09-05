module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |exception|
      json_response({ message: exception.message }, :not_found)
    end
  end
end

# When you call extend ActiveSupport::Concern it will look for a ClassMethods inner-module and will extend your 'host' class with that. Then it will provide you with an included method which you can pass a block to:
#
# included do
#  some_function
# end
# The included method will be run within the context of the included class. If you have a module that requires functions in another module, ActiveSupport::Concern will take care of the dependencies for you.
