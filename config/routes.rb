Rails.application.routes.draw do


  root 'home_page#home'
  get 'load' => 'home_page#load'
  post 'import' => 'home_page#import'
  get 'archives' => 'home_page#archives'


  resources :people_secretsantas , param: :year, only: [:show, :destroy]
  resources :people, only: [:show, :index]


end
