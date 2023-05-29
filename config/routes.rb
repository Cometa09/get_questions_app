Rails.application.routes.draw do

  resource :session, only: [:new, :create, :destroy]

  resources :users, only: [:new, :create, :edit, :update]
  
  resources :questions do 
    resources :answers, except: [:new, :show]
  end

  #get '/questions', to: 'questions#index'
  #get '/questions/new', to: 'questions#new'
  #get '/questions/:id/edit', to: 'questions#edit'
  #post '/questions', to: 'questions#create'
  
  root 'pages#index'
end
