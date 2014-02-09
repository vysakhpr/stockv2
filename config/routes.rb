Stockv2::Application.routes.draw do

  get "admin/sign_out", to:"admin#sign_out"
  post "admin/sign_in", to:"admin#sign_in"
  post "admin/create", to:"admin#create"
  get "/admin/register", to: "admin#register"
  get "/principal",to:"admin#principal"
  get "/office",to:"admin#office"

  get "admin/login",to:"admin#login"
  get "office/new",to:"office#new"
  post "office/show/:id",to:"office#show"
  delete "office/delete",to:"office#delete"
  post "office/create", :to => 'office#create'

  post "labstock/new/:id",to:"labstock#new"
  get "labstock/show",to:"labstock#show"
  get "labstock/delete",to:"labstock#delete"
  post "labstock/create",to:"labstock#create"

  get "lab/register", to:"lab#register"
  post "lab/create", to: "lab#create"
  post "lab/sign_in", to: "lab#sign_in"
  get "lab/sign_out", to: "lab#sign_out"
  get "lab/index",to:"lab#index"
  get "lab/login",to:"lab#login"
  get "lab/perfect",to: "lab#perfect"
  get "lab/repair",to: "lab#repair"
  get "lab/irrepair",to: "lab#irrepair"

  get "department/register", to:"department#register"
  post "department/create", to:"department#create"
  post "department/sign_in", to:"department#sign_in"
  get "department/sign_out", to:"department#sign_out"
  get "department/index",to:"department#index"
  get "department/login",to:"department#login"

  get "home/index",to:"home#index"

  root :to => 'home#index'

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
