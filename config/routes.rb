# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'time_statistics', :to => 'time_statistics#index'
get 'projects/:project_id/time_statistics', :to => 'time_statistics#index', :as => 'project_time_statistics'

post 'time_statistics/update_entries', :to => 'time_statistics#update_entries'