ActionController::Routing::Routes.draw do |map|
  #map.resources :cats
map.resources :cats, :collection => { :demo => [:get, :post] } 
#2009-06-23メンテナンス
  map.connect 'test/:controller', :action => 'test'
=begin ■　独自アクションのＵＲＬ
# map.connect 'aux/:controller/:action'
#restfulにすることで.pdfなどの振り分け可能、独自アクションをcollection/getで追記
=end
  map.resources :reports,
    :collection => {
      :taiju => :get, :icon => :get, :jidou_reg => :get, 
      :kosei => :get, :hiyari_hat => :get, :group_diary => :get,
      :slide_01 => :get,  :slide_02 => :get, :slide_03 => :get, :update_jido_staff_rels => :get,
      :slide_04 => :get,  :slide_05 => :get, :slide_06 => :get, :slide_07 => :get, :slide_08 => :get
    }
  #map.resources :extras
  map.resources :message_staff_rels
  map.resources :messages
  map.resources :staff_recs
  map.resources :admins
  map.resources :tanki_shien_mokuhyos
  map.resources :group_recs
  map.resources :accounts
  map.resources :day_recs
  map.resources :case_recs
  map.resources :shien_keikakus
  map.resources :daichos
  map.resources :links
  map.resources :jidos

  map.resources :users #ADDED
  map.resource :session #ADDED

  map.resources :attends
  map.resources :attends, :collection => {:dsp => :get}

  map.resources :jido_edu_rels
  map.resources :edu_jido_rels

  map.resources :edu_insts
  map.resources :med_insts
  map.resources :jido_guardian_rels
  map.resources :guardians
  map.resources :jido_grp_rels
  map.resources :jido_grp_rels, :collection => {:sort_grp => :get}

  map.resources :groups
  map.resources :med_recs
  map.resources :stay_out_recs
  map.resources :school_recs
  map.resources :shidou_recs, :collection => {:hiyari_hat => :get}

  map.resources :rels
  map.resources :staffs
  map.resources :boys
  map.resources :boys, :collection => { :hey => :put }

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "welcome"
   map.root :controller => "sessions", :action => "new"
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users',    :action => 'new'
  map.login '/login',   :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

end