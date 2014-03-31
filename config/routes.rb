Stockv2::Application.routes.draw do

  post "user/sign_in", to:"home#sign_in"

  get "admin/sign_out", to:"admin#sign_out"
  post "admin/sign_in", to:"admin#sign_in"
  post "admin/create", to:"admin#create"
  get "/admin/register", to: "admin#register"
  get "/principal",to:"admin#principal"
  get "/office",to:"admin#office"
  post "admin/password_change", to:"admin#password_change"
  post "admin/password/:id",to:"admin#password"


  get "admin/login",to:"admin#login"
  get "office/new",to:"office#new"
  post "office/show/:id",to:"office#show"
  delete "office/delete",to:"office#delete"
  post "office/create", :to => 'office#create'

  post "labstock/new/:id",to:"labstock#new"
  get "labstock/show",to:"labstock#show"
  get "labstock/delete",to:"labstock#delete"
  post "labstock/create",to:"labstock#create"
  post "labstock/transfer",to:"labstock#transfer"
  post "labstock/writeoff/:id",to: "labstock#writeoff"

  get "lab/register", to:"lab#register"
  post "lab/create", to: "lab#create"
  post "lab/sign_in", to: "lab#sign_in"
  get "lab/sign_out", to: "lab#sign_out"
  get "lab/index",to:"lab#index"
  get "lab/login",to:"lab#login"
  post "lab/update/:id", to:"lab#update"
  post "lab/update_used/:id", to:"lab#update_used"
  get "lab/search",to:"lab#search"
  post "lab/password_change", to:"lab#password_change"
  post "lab/password/:id",to:"lab#password"



  get "department/register", to:"department#register"
  post "department/create", to:"department#create"
  post "department/sign_in", to:"department#sign_in"
  get "department/sign_out", to:"department#sign_out"
  get "department/index",to:"department#index"
  get "department/login",to:"department#login"
  get "department/transfer/:id", to: "department#transfer"
  post "department/transfer_update", to: "department#transfer_update"
  post "department/password_change", to: "department#password_change"
  post "department/password/:id",to:"department#password"

  post "message/writeoff", to:"message#writeoff"
  post "message/need_stock", to:"message#need_stock"
  post "message/department_ack/:id",to:"message#department_ack"
  post "message/request_forward/:id",to:"message#request_forward"
  post "message/request_deny/:id",to: "message#request_deny"
  post "message/principal_deny/:id",to:"message#principal_deny"
  post "message/principal_acknowledge/:id",to: "message#principal_acknowledge"
  delete "message/acknowledgement_delete/:id", to: "message#acknowledgement_delete"
  delete "message/principal_writeoff/:id",to: "message#principal_writeoff"  

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
