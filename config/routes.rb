Rails.application.routes.draw do
  resources :passwords,
    :controller => 'clearance/passwords',
    :only       => [:new, :create]

  resource  :session,
    :controller => 'clearance/sessions',
    :only       => [:new, :create, :destroy]

  resources :users, :controller => 'clearance/users', :only => [:new, :create] do
    resource :password,
      :controller => 'clearance/passwords',
      :only       => [:create, :edit, :update]

    resource :confirmation,
      :controller => 'clearance/confirmations',
      :only       => [:new, :create]
  end

  match 'signup1'  => 'clearance/users#new', :as => 'sign_up'
  match 'login'  => 'clearance/sessions#new', :as => 'sign_in'
  match 'logout' => 'clearance/sessions#destroy', :via => :delete, :as => 'sign_out'
end
