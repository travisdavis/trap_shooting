Rails.application.config.middleware.use OmniAuth::Builder do
  # If you don't need a refresh token -- if you're only using Google for account creation/auth and don't need google services -- set the access_type to 'online'.
  # Also, set the approval prompt to an empty string, since otherwise it will be set to 'force', which makes users manually approve to the Oauth every time they log in.
  # See http://googleappsdeveloper.blogspot.com/2011/10/upcoming-changes-to-oauth-20-endpoint.html
  #provider :facebook, 'APP_ID', 'APP_SECRET'
  #privider :github, 'APP_ID', 'APP_SECRET'
  #provider :google_oauth2, ENV['739780853210.apps.googleusercontent.com'], ENV['Vmsz615rLXrbaksnJgsdoblQ'], {access_type: 'online', approval_prompt: ''}
  #provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  provider :twitter, 'UxT6DOCbPCuE87yqKRfwNA', 'm2Tx1fp4CwgU3OooBCiT9FiPtHYPl6lq8VTFiZ9y68o'
end
