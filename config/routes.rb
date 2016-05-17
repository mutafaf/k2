Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  mount Shoppe::Engine => "/admin"

  Shoppe::Engine.routes.draw do
    resources :sizes
    resources :subscribers
    resources :jobs
    resources :stores do
      collection do
        get :import
        post :import
      end
    end
    resources :brands
  end

  get 'home/index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get "product/:permalink", to: "products#show", as: "product"
  post "product/:permalink", to: "products#buy", as: "buy"

  get "brand/:permalink", to: "home#brand_page", as: "brand"
  # root to: "products#index"

  post "product/:permalink", to: "products#buy"
  get "basket", to: "orders#show"
  delete "basket", to: "orders#destroy"
  post "update_order_items", to: "orders#update_order_items"
  get "get_order_address", to: "orders#get_order_address"

  match "checkout", to: "orders#checkout", as: "checkout", via: [:get]
  match "checkout/details", to: "orders#details", as: "checkout_details", via: [:get, :patch, :post]
  match "checkout/pay", to: "orders#payment", as: "checkout_payment", via: [:get, :post]
  match "checkout/confirm", to: "orders#confirmation", as: "checkout_confirmation", via: [:get, :post]

  get "products", to: "products#index"

   get "blog", to: "home#blog"
   get "videos", to: "home#videos"
   get "store_location", to: "home#store_location"
   get "about_us", to: "home#about_us"
   get "contact_us", to: "home#contact_us"
   post '/contact' => "home#contact"
   get "careers", to: "home#careers"
   post "add_subscriber", to: "home#add_subscriber"

   devise_for :users , :controllers => { :sessions => "sessions", :registrations => "registrations"}

  root to: "home#index"
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
