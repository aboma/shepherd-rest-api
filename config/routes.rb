ShepherdDAM::Application.routes.draw do

  current_api_routes = lambda do
    match '*all' => 'application#cors_preflight_check', :via => :options

    devise_scope :user do
      resources :users, :only => [:index, :create, :show, :update], :defaults => { :format => :json }
      resources :sessions, :only => [:index, :create, :destroy, :show]
      get "logout" => "sessions#destroy", :as => "logout"
      get "login" => "sessions#new", :as => "login"
    end

    resources :settings, :defaults => { :format => :json }
    resources :portfolios, :defaults => { :format => :json }

    # serve assets under root directory or portfolio directory
    scope '(portfolios/:portfolio_id)' do 
      resources :relationships, :only => [:index, :show, :create, :destroy], :defaults => { :format => :json } 
      resources :assets, :defaults => { :format => :json } do
        resources :metadata, :only => [:index], :defaults => { :format => :json }
        resources :files, :only => [:show], :format => :html
      end
    end

    resources :relationships, :only => [:index, :show, :create, :update, :destroy], :defaults => { :format => :json }
    resources :metadatum_fields, :only => [:index, :show, :create, :update, :destroy], :defaults => { :format => :json }
    resources :metadatum_list_values, :only => [:index, :show, :create], :defaults => { :format => :json }
    resources :metadatum_values_lists, :only => [:index, :show, :create, :update, :destroy], :defaults => { :format => :json }
    resources :metadata_template_field_settings, :only => [:index, :show, :create, :update, :destroy], :defaults => { :format => :json }
    resources :metadata_templates, :only => [:index, :show, :create, :update, :destroy], :defaults => { :format => :json }

    root :to => "application#index", :defaults => { :format => :json }

  end

  constraints ApiVersion.new(:version => 1, :default => true) do
    scope :module => :v1, :constraints => ApiVersion.new(:version => 1, :default => true), &current_api_routes
    devise_for :users, :path_names => { :sign_up => "login" }, :class_name => 'V1::User'
  end

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
  #     member dorail
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
  # match ':controller(/:action(/:id(.:format)))'
end
