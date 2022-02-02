module TimeStatisticsHelper

  def _time_statistics_path(project, issue, *args)
    if project
        project_time_statistics_path(project, *args)
    else
      time_statistics_path(*args)
    end
  end

  def select_hours_by_user(report, user)
    report.time_statistics.collect{ |x| (x.total_user_spent_hours[:users].nil? ? 0 : x.total_user_spent_hours[:users].select{|k,v| k == user[:id]}.collect{|k, v| v.to_f}) }.flatten
  end

  def link_to_if_with_spent_time(condition, label, issue, query, user_id = nil)
    spent_on_filter = query.filters["time.time_spent_on"]
    time_activity_filter = query.filters["time.time_activity"]

    if user_id.nil?
      if spent_on_filter.nil? && time_activity_filter.nil?
        link_to_if(condition, label, project_time_entries_path(issue.project, :issue_id => "~#{issue.id}"))
      else
        f = [:issue_id]
        f << :spent_on unless spent_on_filter.nil?
        f << :activity_id unless time_activity_filter.nil?
        args = {
          "f" => f, 
          "op[issue_id]" => "~",
          "v[issue_id]" => ["#{issue.id}"]
        }
        args.merge!({ "op[spent_on]" => "#{spent_on_filter[:operator]}" })          unless spent_on_filter.nil?
        args.merge!({ "v[spent_on]" => spent_on_filter[:values] })                  unless spent_on_filter.nil?
        args.merge!({ "op[activity_id]" => "#{time_activity_filter[:operator]}" })  unless time_activity_filter.nil?
        args.merge!({ "v[activity_id]" => time_activity_filter[:values] })          unless time_activity_filter.nil?
       
        link_to_if(condition, label, project_time_entries_path(issue.project, args));
      end
    else
      if spent_on_filter.nil? && time_activity_filter.nil?
        link_to_if(condition, label, project_time_entries_path(issue.project, :issue_id => "~#{issue.id}", :user_id => "#{user_id}"))
      else
        f = [:issue_id, :user_id]
        f << :spent_on unless spent_on_filter.nil?
        f << :activity_id unless time_activity_filter.nil?
        args = {
          "f" => f, 
          "op[issue_id]" => "~",
          "v[issue_id]" => ["#{issue.id}"],
          "op[user_id]" => "=",
          "v[user_id]" => ["#{user_id}"],
        }
        args.merge!({ "op[spent_on]" => "#{spent_on_filter[:operator]}" })          unless spent_on_filter.nil?
        args.merge!({ "v[spent_on]" => spent_on_filter[:values] })                  unless spent_on_filter.nil?
        args.merge!({ "op[activity_id]" => "#{time_activity_filter[:operator]}" })  unless time_activity_filter.nil?
        args.merge!({ "v[activity_id]" => time_activity_filter[:values] })          unless time_activity_filter.nil?

        link_to_if(condition, label, project_time_entries_path(issue.project, args))
      end
    end
  end

  def link_total_with_spent_time(condition, label, query, project, user_id = nil)
    spent_on_filter = query.filters["time.time_spent_on"]
    time_activity_filter = query.filters["time.time_activity"]

    if project.nil?
      if user_id.nil?
        if spent_on_filter.nil? && time_activity_filter.nil?
          link_to_if(condition, label, time_entries_path())
        else
          f = []
          f << :spent_on unless spent_on_filter.nil?
          f << :activity_id unless time_activity_filter.nil?
          args = {"f" => f}
          args.merge!({ "op[spent_on]" => "#{spent_on_filter[:operator]}" })          unless spent_on_filter.nil?
          args.merge!({ "v[spent_on]" => spent_on_filter[:values] })                  unless spent_on_filter.nil?
          args.merge!({ "op[activity_id]" => "#{time_activity_filter[:operator]}" })  unless time_activity_filter.nil?
          args.merge!({ "v[activity_id]" => time_activity_filter[:values] })          unless time_activity_filter.nil?

          link_to_if(condition, label, time_entries_path(*args))
        end
      else
        if spent_on_filter.nil? && time_activity_filter.nil?
          link_to_if(condition, label, time_entries_path(:user_id => "#{user_id}"))
        else
          f = [:user_id]
          f << :spent_on unless spent_on_filter.nil?
          f << :activity_id unless time_activity_filter.nil?
          args = {
            "f" => f, 
            "op[user_id]" => "=",
            "v[user_id]" => ["#{user_id}"]
          }
          args.merge!({ "op[spent_on]" => "#{spent_on_filter[:operator]}" })          unless spent_on_filter.nil?
          args.merge!({ "v[spent_on]" => spent_on_filter[:values] })                  unless spent_on_filter.nil?
          args.merge!({ "op[activity_id]" => "#{time_activity_filter[:operator]}" })  unless time_activity_filter.nil?
          args.merge!({ "v[activity_id]" => time_activity_filter[:values] })          unless time_activity_filter.nil?

          link_to_if(condition, label, time_entries_path(args))
        end
      end
    else
      if user_id.nil?
        if spent_on_filter.nil? && time_activity_filter.nil?
          link_to_if(condition, label, project_time_entries_path(project))
        else
          f = []
          f << :spent_on unless spent_on_filter.nil?
          f << :activity_id unless time_activity_filter.nil?
          args = {"f" => f}
          args.merge!({ "op[spent_on]" => "#{spent_on_filter[:operator]}" })          unless spent_on_filter.nil?
          args.merge!({ "v[spent_on]" => spent_on_filter[:values] })                  unless spent_on_filter.nil?
          args.merge!({ "op[activity_id]" => "#{time_activity_filter[:operator]}" })  unless time_activity_filter.nil?
          args.merge!({ "v[activity_id]" => time_activity_filter[:values] })          unless time_activity_filter.nil?

          link_to_if(condition, label, project_time_entries_path(project, args))
        end
      else
        if spent_on_filter.nil? && time_activity_filter.nil?
          link_to_if(condition, label, project_time_entries_path(project, :user_id => "#{user_id}"))
        else
          f = [:user_id]
          f << :spent_on unless spent_on_filter.nil?
          f << :activity_id unless time_activity_filter.nil?
          args = {
            "f" => f, 
            "op[user_id]" => "=",
            "v[user_id]" => ["#{user_id}"]
          }
          args.merge!({ "op[spent_on]" => "#{spent_on_filter[:operator]}" })          unless spent_on_filter.nil?
          args.merge!({ "v[spent_on]" => spent_on_filter[:values] })                  unless spent_on_filter.nil?
          args.merge!({ "op[activity_id]" => "#{time_activity_filter[:operator]}" })  unless time_activity_filter.nil?
          args.merge!({ "v[activity_id]" => time_activity_filter[:values] })          unless time_activity_filter.nil?

          link_to_if(condition, label, project_time_entries_path(project,  args))
        end
      end
    end

  end

  def sum_hours(hours)
    sum = 0
    hours.each do |row|
      sum += row.to_f
    end
    sum
  end

  def report_to_csv(report, query, csv_params)
    columns = query.columns

    Redmine::Export::CSV.generate do |csv|
      # Column headers
      headers = columns.map {|c| c.caption.to_s}
      headers += report.users.map {|c| c[:name].to_s}
      headers << l(:label_total_time)
      csv << headers
      # Content
      report.time_statistics.each do |time_statistic|
        row = columns.map {|c| csv_content(c, time_statistic.issue)}
        row += report.users.map {|c| csv_user(c, time_statistic.total_user_spent_hours[:users])}
        row << (time_statistic.total_user_spent_hours[:total] || 0)
        csv << row
      end
      # Total row
      # str_total = l(:label_total_time)
      # row = [ str_total ] + [''] * (report.criteria.size - 1)
      # total = 0
      # report.periods.each do |period|
      #   sum = sum_hours(select_hours(report.hours, report.columns, period.to_s))
      #   total += sum
      #   row << (sum > 0 ? sum : '')
      # end
      # row << total
      # csv << row
    end
  end

  def csv_user(user, datas)
    unless datas.nil?
      datas[user[:id]] || 0
    else  
      0
    end
  end

  def time_statistics_to_pdf(report, query)
      issues = report.time_statistics.collect{|x| x.issue}

      pdf = Redmine::Export::PDF::ITCPDF.new(current_language, "L")
      pdf.set_title("Test")
      pdf.alias_nb_pages
      pdf.footer_date = format_date(User.current.today)
      pdf.set_auto_page_break(false)
      pdf.add_page("L")

      # Landscape A4 = 210 x 297 mm
      page_height   = pdf.get_page_height # 210
      page_width    = pdf.get_page_width  # 297
      left_margin   = pdf.get_original_margins['left'] # 10
      right_margin  = pdf.get_original_margins['right'] # 10
      bottom_margin = pdf.get_footer_margin
      row_height    = 4

      # column widths
      table_width = page_width - right_margin - left_margin
      col_width = []
      unless query.inline_columns.empty?
        col_width = calc_col_width(issues, query, table_width, pdf)
        table_width = col_width.inject(0, :+)
      end

      # use full width if the description or last_notes are displayed
      if table_width > 0 && (query.has_column?(:description) || query.has_column?(:last_notes))
        col_width = col_width.map {|w| w * (page_width - right_margin - left_margin) / table_width}
        table_width = col_width.inject(0, :+)
      end

      # title
      pdf.SetFontStyle('B',11)
      pdf.RDMCell(190, 8, title)
      pdf.ln

      # totals
      totals = query.totals.map {|column, total| "#{column.caption}: #{total}"}
      if totals.present?
        pdf.SetFontStyle('B',10)
        pdf.RDMCell(table_width, 6, totals.join("  "), 0, 1, 'R')
      end
      
      pdf.output

  end

end