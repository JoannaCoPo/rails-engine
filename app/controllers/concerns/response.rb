# frozen_string_literal: true

module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def search_error
    render json: { error: 'Invalid request' }, status: 400
  end
end
