# frozen_string_literal: true

module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def no_match
    render json: { error: 'Not found', messages: ['Unable to find any results that match the search criteria.'] },
           status: 404
  end
end
