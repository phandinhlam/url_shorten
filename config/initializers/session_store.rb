Rails.application.config.session_store :cookie_store, key: '_url_shorten_session',
                                                      httponly: true,
                                                      secure: Rails.env.production?
