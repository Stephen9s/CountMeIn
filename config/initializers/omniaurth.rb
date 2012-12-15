#app/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '211364911830.apps.googleusercontent.com', 'DfYOTuecITqdsBzETXJJPzQz', {
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar',
    redirect_uri: 'http://localhost/auth/google_oauth2/callback',
    client_options: {ssl: {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}}
  }
end