Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'api/v1/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
