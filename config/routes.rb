Twitfollowers::Application.routes.draw do
  root :to => 'users#index'
  match 'user/:data' => 'users#show'
  match 'user' => 'users#index'
end
