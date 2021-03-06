Rails.application.routes.draw do

  root 'home/welcome#welcome'

  scope '/home', module: 'home' do
    post   "oauth/callback"  => "oauths#callback"
    get    "oauth/callback"  => "oauths#callback" # for use with Github, Facebook
    get    "oauth/:provider" => "oauths#oauth",           as: :auth_at_provider
    get  'login'             => 'user_sessions#new',      as: :login
    get  'signup'            => 'users#new',              as: :signup
    resource :user_sessions, only: [:new, :create]
    resources :users, only: [:new, :create]
  end

  scope '/dashboard', module: 'dashboard' do
    get 'trainer'            => 'trainer#index',           as: :trainer
    post "check_card"        => "trainer#check_card"
    post 'logout'            => 'user_sessions#destroy',   as: :logout
    put 'reset_repetitions'  => 'cards#reset_repetitions', as: :reset_repetitions
    put 'reset_efactor'      => 'cards#reset_efactor',     as: :reset_efactor
    delete "oauth/:provider" => "oauths#destroy",          as: :delete_oauth
    resource :user_sessions, only: :destroy
    resources :users, only: [:edit, :update, :destroy]
    resources :cards
    resources :decks do
      member do
        put 'make_current'
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
