set :stage, :development
set :rails_env, :development
set :deploy_to, '/deploy/apps/url_shorten'
set :branch, :deploy
server '54.179.205.148', user: 'www', roles: %w(web app db)
