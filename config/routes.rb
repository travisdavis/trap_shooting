TrapShooting::Application.routes.draw do
  root :to => 'static#login'

  resources :seasons do
    resources :teams
    resources :matches
  end

  resources :teams do
    resources :shooters
  end

  resources :shooters

  resources :matches do
    resources :results
  end

  resources :results

  resources :bigboards, :only => [:index, :show]

  # authentication routes
  match "/auth/:provider/callback", to: "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  # static pages
  match ':action' => 'static#:action'
end
