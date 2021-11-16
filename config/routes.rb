Rails.application.routes.draw do
  namespace :customer do
    get 'products/index'
    get 'products/show'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # 管理者
  
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations'
  }

  namespace :admins do
    root to: 'homes#top'
    resources :customers, only: [:index,:show,:edit,:update]
    resources :orders, only: [:show,:update]
    resources :order_details, only: [:update]
    resources :products, except: [:destroy]
    resources :genres, only: [:index, :edit, :create, :update]
  end
  
  # 会員
  
  devise_for :customers, controllers: {
    sessions: 'customers/sessions',
    registrations: 'customers/registrations',
    passwords: 'customers/passwords'
  }
  
  scope module: :customers do

    ##トップページ・アバウトページ(homes)
    root :to => 'homes#top'
    get '/about' => 'homes#about'
    
    ##会員(customers)
    resources :customers,only: [:edit, :update, :show]
    
    ##退会(quit/out)
    get 'customers/quit' => 'customers#quit'
    patch 'customers/out' => 'customers#out'
    
    ##配送先(shipping_addresses)
    resources :shipping_addresses,only: [:create, :index, :edit, :update, :destroy]
    
    ##商品(products)
    resources :products, only: [:index, :show]
  
    ##ショッピングカート(cart_items)
    resources :cart_items, only: [:index, :create, :update, :destroy]
    delete 'cart_items/destroy_all' => 'cart_items#destroy_all'
  
    ##注文(orders)
    resources :orders, only: [:index, :show, :new, :create]
    post 'orders/confirm' => 'orders#confirm'
    get 'orders/success' => 'orders#success'
  end
  
end
