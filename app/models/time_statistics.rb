class TimeStatistics

  def initialize(issue)
    @issue = issue
    @total_user_spent_hours = []
  end

  def issue
    @issue
  end

  def project
    @issue.project
  end

  def tracker
    @issue.tracker
  end 

  def status
    @issue.status
  end

  def author
    @issue.author
  end

  def total_user_spent_hours
    @total_user_spent_hours
  end

  def self.load_visible_user_total_spent_hours(time_statistics, sql_for_time_spent_on_where, user=User.current)
    if time_statistics.any?
      hours_by_issue_and_users = TimeEntry.visible(user).
        joins(:issue).
        joins("JOIN #{Issue.table_name} parent ON parent.root_id = #{Issue.table_name}.root_id AND parent.lft <= #{Issue.table_name}.lft AND parent.rgt >= #{Issue.table_name}.rgt").
        where("parent.id IN (?) #{sql_for_time_spent_on_where.blank? ? "" : "AND #{sql_for_time_spent_on_where}"}", time_statistics.collect{|x| x.issue.id}).
        group(["parent.id", "#{TimeEntry.table_name}.user_id"]).
        sum(:hours) 

      hours_by_user_id_by_issue_id = {}
      hours_by_issue_and_users.each do |key, value|
        issue_id = key[0]
        user_id = key[1]
        unless hours_by_user_id_by_issue_id.include? issue_id
            hours_by_user_id_by_issue_id[issue_id] = { :users => {}, :total => 0.0 }
        end  
        hours_by_user_id_by_issue_id[issue_id][:users][user_id] = value
        hours_by_user_id_by_issue_id[issue_id][:total] += value
      end

      time_statistics.each do |time_statistic|
        time_statistic.instance_variable_set "@total_user_spent_hours", (hours_by_user_id_by_issue_id[time_statistic.issue.id] || {})
      end
    end
  end 

  def self.remove_issue_without_spent_time(time_statistics)
    time_statistics.select{|x| (x.total_user_spent_hours[:total] || 0) > 0}
  end

end