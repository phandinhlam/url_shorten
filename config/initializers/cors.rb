# TODO: Can use this regex aaply for allow_origin when we has domain
# [%r{^(?:https?:\/\/)?(?:\S*\.)?abc\.(\bcom|\binfo|\bnet)(([\/?#])?|[\/\?\#].{0,})$}]
allow_origins = '*'
allow_origins += Settings.allow_origins if Settings.allow_origins

Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: true, logger: (-> { Rails.logger }) do
  allow do
    origins allow_origins
    resource '*', headers: :any, methods: %i[get post patch put delete]
  end
end
