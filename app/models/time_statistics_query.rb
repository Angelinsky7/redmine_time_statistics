class TimeStatisticsQuery < IssueQuery

  def initialize(attributes=nil, *args)
    super attributes
    self.filters = { 
      'status_id' => {:operator => "o", :values => [""]},
      'time.time_spent_on' => {:operator => "*", :values => []} 
    }
  end  

  def initialize_available_filters
    add_available_filter("time.time_spent_on", :type => :date_past, :name => l(:label_time, :name => l(:label_time_spent_on)),)

    super
  end

  def default_columns_names
      super
      @default_columns_names += [:done_ratio]
  end

  def sql_for_time_time_spent_on_field(field, operator, value)
    ""
  end

  def sql_for_time_time_spent_on_where(filter)
    unless filter.nil?
      sql_for_field("time.time_spent_on", filter[:operator], filter[:values], TimeEntry.table_name, "spent_on", false)
    end
  end

end