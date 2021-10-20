Rails.application.routes.draw do
  get 'pages/table'
  get 'pages/local'
  get 'pages/compare'
  root 'application#hello'
end
