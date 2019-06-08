Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get 'reviews' => 'reviews#show'
    end
  end
end
