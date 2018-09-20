Rails.application.routes.draw do
  root :to => 'top#index'
  post 'top/result'
  get 'top/result' => 'top#index'
  get 'top/result/:keyword/:page' => 'top#result'
  get 'top/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
