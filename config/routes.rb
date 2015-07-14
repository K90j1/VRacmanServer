VRacmanServer::Application.routes.draw do
  resources :scores
	get 'HighScore' => 'scores#show'
	post 'AddUser' => 'scores#create'
end
