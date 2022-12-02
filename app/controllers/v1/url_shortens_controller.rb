class V1::UrlShortensController < ActionController::Base
  def encode
    render(json: { code: 200, data: { url: '123' } })
  end

  def decode
    render(json: { code: 200, data: { url: '321' } })
  end
end
