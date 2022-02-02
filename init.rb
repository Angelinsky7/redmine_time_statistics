QueriesController.send(:include, RedmineTimeStatistics::QueriesControllerPatch)

Redmine::Plugin.register :redmine_time_statistics do
  name 'Parent Time'
  author 'Angelinsky7'
  description 'Parent time from children'
  version '0.0.2'
  url 'https://github.com/Angelinsky7/redmine_time_statistics.git'
  author_url 'https://github.com/Angelinsky7/redmine_time_statistics.git'

  project_module :redmine_time_statistics do
    permission :view_time_statistics, :time_statistics => :index

    menu :application_menu, :time_statistics, { :controller => 'time_statistics', :action => 'index' }, :caption => :label_time_statistics
    menu :project_menu, :time_statistics, { :controller => 'time_statistics', :action => 'index' }, :caption => :label_time_statistics, :param => :project_id
  end
 
end
 