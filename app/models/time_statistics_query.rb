class TimeStatisticsQuery < IssueQuery

  self.available_columns = IssueQuery.available_columns + [
    QueryColumn.new(:show_all_issue, :caption => :label_show_all_issue, :inline => false)
  ]

  def initialize(attributes=nil, *args)
    super attributes
    self.filters = { 
      'status_id' => {:operator => "o", :values => [""]},
      'time.time_spent_on' => {:operator => "*", :values => []}
    }
  end  

  def initialize_available_filters
    activities = (project ? project.activities : TimeEntryActivity.shared)
    
    add_available_filter("time.time_spent_on", :type => :date_past, :name => l(:label_time, :name => l(:label_time_spent_on)),)
    add_available_filter("time.time_activity", :type => :list, :values => activities.map {|a| [a.name, a.id.to_s]}, :name => l(:label_activity, :name => l(:label_time_activity)),)

    super
  end

  def default_columns_names
      super
      @default_columns_names += [:done_ratio]
  end

  def sql_for_time_time_spent_on_field(field, operator, value)
    ""
  end

  def sql_for_time_time_activity_field(field, operator, value)
    ""
  end

  def sql_for_time_time_spent_on_where(filter)
    unless filter.nil?
      sql_for_field("time.time_spent_on", filter[:operator], filter[:values], TimeEntry.table_name, "spent_on", false)
    end
  end

  def sql_for_time_time_activity_where(filter)
    unless filter.nil?
      sql_for_field("time.time_entry_activity", filter[:operator], filter[:values], TimeEntry.table_name, "activity_id", false)
    end
  end

  def show_only_issue_with_spent_time
    !has_column?(:show_all_issue)
  end

end