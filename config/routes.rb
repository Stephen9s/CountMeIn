CountMeIn::Application.routes.draw do
  
  
  resources :authentications
  
  get "sessions/friends"
  post "sessions/loadEvent"
  get "sessions/loadEvent"
  
  post "authentications/add_event"
  post "authentications/remove_event"
  match '/auth/:provider/callback' => 'authentications#create'
  
  resources :friendships

  get "events/new"
  post "/events/create"
  get "events/create"

  get "events/update"

  get "events/edit"

  post "events/destroy"

  get "events/index"

  get "events/show"

  root :to => "sessions#login"
  match "signup", :to => "users#new"
  match "login", :to => "sessions#login"
  match "login_attempt", :to => "sessions#login_attempt"
  match "logout", :to => "sessions#logout"
  match "home", :to => "sessions#home"
  match "profile", :to => "sessions#profile"
  match "setting", :to => "sessions#setting"
  
  #friendship
  match "friends", :to => "sessions#friends", :as => "friends"
  post "sessions/friends"
  post "friendships/create"
  put "friendships", :to => "friendships#edit"
  delete "friendships", :to => "friendships#delete"
  
  resources :users
  get "users/new"
  match "/users/:user" => "users#create"
  match "search" => "users#search"
  
  resources :events
  match "events", :to => "events#index", :as => "events"
  match "post" => "events#new"
  match "/events/:id" => "events#show", :as => "show_event"
  put "/events/:id/edit", :to => "events#edit", :as => "edit_event"
  post "events/create"
  post "/events/:id", :to => "events#update"
  #put "events", :to => "events#edit"
  post "/event/:id/destroy", :to => "events#destroy"
  match "searchevents" => "events#search"
  
  # RSS
  match '/feed' => 'events#feed',
      :as => :feed,
      :defaults => { :format => 'atom' }
  
  match "agenda" => "agenda#index"

  resources :memberships
  match "join" => "memberships#create"
  match "leave" => "memberships#destroy"
  post "memberships/create"
  post "memberships/destroy"
  
  resources :messages, :message_recipients
  match "inbox" => "messages#index"
  match "inbox/new" => "messages#new"
  match "inbox/view/:message" => "messages#view"
  post "inbox/view"
  post "/inbox/:message/destroy" => "messages#destroy"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   # match ':controller(/:action(/:id))(.:format)'
end
