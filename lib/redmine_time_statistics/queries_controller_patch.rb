require_dependency "queries_controller"

module RedmineTimeStatistics
  module QueriesControllerPatch
    def self.included(base)
      base.class_eval do

        def redirect_to_time_statistics_query(options)
          if @project.nil?
            redirect_to time_statistics_path(options)
          else
            redirect_to project_time_statistics_path(@project, nil, options)
          end
        end

      end
    end
  end
end