module RedmineTimeStatistics
  module Helpers
    class TimeStatisticsReport

      attr_reader :time_statistics, :users

      def initialize(project, time_statistics_scope, query)
        @project = project                
        @scope = time_statistics_scope
        @query = query
               
        run
      end

      def available_columns
        @available_columns || load_available_columns
      end

      def valid?
        time_statistics.any?
      end

      private

      def run
        sql_query_filter = @query.sql_for_time_time_spent_on_where(@query.filters["time.time_spent_on"])
        sql_second_query_filter = @query.sql_for_time_time_activity_where(@query.filters["time.time_activity"])
        
        @time_statistics = @scope.collect {|x| TimeStatistics.new(x)}
        TimeStatistics.load_visible_user_total_spent_hours(@time_statistics, sql_query_filter, sql_second_query_filter)

        if @query.show_only_issue_with_spent_time
          @time_statistics = TimeStatistics.remove_issue_without_spent_time(@time_statistics)
        end if

        load_visible_user_that_spent_hours(@time_statistics)        
      end

      def load_visible_user_that_spent_hours(time_statistics, user=User.current)
        if time_statistics.any?
          user_ids = TimeEntry.visible(user).
            joins(:issue).
            joins("JOIN #{Issue.table_name} parent ON parent.root_id = #{Issue.table_name}.root_id AND parent.lft <= #{Issue.table_name}.lft AND parent.rgt >= #{Issue.table_name}.rgt").
            where("parent.id IN (?)", time_statistics.collect{|x| x.issue.id}).
            distinct("#{TimeEntry.table_name}.user_id")
        
          # TODO(demarco): We should make this an option in the settings
          status_ids = [1]
          @users = User.where("id IN (?) AND status IN (?)", user_ids.map(&:user_id), status_ids.map(&:to_s)).collect{|x| {:id => x.id, :login => x.login, :name => x.name } }
        end
      end

    end
  end
end