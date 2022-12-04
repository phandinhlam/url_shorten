module RequestHelper
  def response_body
    JSON.parse(response.body, symbolize_names: true)
  rescue JSON::ParserError, TypeError
    {}
  end
end
