# frozen_string_literal: true

class V1::UrlShortensController < V1::BaseController
  def encode
    url = Link.encode(params[:url])
    render_success(data: { url: url }) && return if url

    link = Link.new(url: params[:url])
    if link.save
      render_success(data: { url: link.full_short_url })
    else
      render_error(data: { message: 'Can\'t create short url, please try agian !!!' })
    end
  end

  def decode
    url = Link.decode(params[:url])
    render_error(code: 400, data: { message: 'Not Found, please try agian !!!' }) && return unless url
    render_success(data: { url: url })
  end
end
