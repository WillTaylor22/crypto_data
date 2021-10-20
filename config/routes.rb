Rails.application.routes.draw do
  get 'table', to: 'pages#table'
  get 'local', to: 'pages#local'
  get 'compare', to: 'pages#compare'
  root 'pages#table'
end
