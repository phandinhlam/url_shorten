# frozen_string_literal: true

module ResponseHandler
  private

  def render_success(code: 200, message: 'OK', data: {})
    render(json: { code: code, message: message, data: data })
  end

  def render_error(code: 500, message: 'NG', data: {})
    render(json: { code: code, message: message, data: data })
  end
end
