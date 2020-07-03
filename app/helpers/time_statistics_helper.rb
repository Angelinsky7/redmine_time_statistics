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




      # pdf.SetFontStyle('B',11)
      # pdf.RDMMultiCell(190,5, project.name)
      # pdf.ln
      # # Set resize image scale
      # pdf.set_image_scale(1.6)
      # pdf.SetFontStyle('',9)
      
      pdf.output







      # pdf = Redmine::Export::PDF::ITCPDF.new(current_language, "L")
      # title = query.new_record? ? l(:label_issue_plural) : query.name
      # title = "#{project} - #{title}" if project
      # pdf.set_title(title)
      # pdf.alias_nb_pages
      # pdf.footer_date = format_date(User.current.today)
      # pdf.set_auto_page_break(false)
      # pdf.add_page("L")

      # # Landscape A4 = 210 x 297 mm
      # page_height   = pdf.get_page_height # 210
      # page_width    = pdf.get_page_width  # 297
      # left_margin   = pdf.get_original_margins['left'] # 10
      # right_margin  = pdf.get_original_margins['right'] # 10
      # bottom_margin = pdf.get_footer_margin
      # row_height    = 4

      # # column widths
      # table_width = page_width - right_margin - left_margin
      # col_width = []
      # unless query.inline_columns.empty?
      #   col_width = calc_col_width(issues, query, table_width, pdf)
      #   table_width = col_width.inject(0, :+)
      # end

      # # use full width if the description or last_notes are displayed
      # if table_width > 0 && (query.has_column?(:description) || query.has_column?(:last_notes))
      #   col_width = col_width.map {|w| w * (page_width - right_margin - left_margin) / table_width}
      #   table_width = col_width.inject(0, :+)
      # end

      # # title
      # pdf.SetFontStyle('B',11)
      # pdf.RDMCell(190, 8, title)
      # pdf.ln

      # # totals
      # totals = query.totals.map {|column, total| "#{column.caption}: #{total}"}
      # if totals.present?
      #   pdf.SetFontStyle('B',10)
      #   pdf.RDMCell(table_width, 6, totals.join("  "), 0, 1, 'R')
      # end

      # totals_by_group = query.totals_by_group
      # render_table_header(pdf, query, col_width, row_height, table_width)
      # previous_group = false
      # result_count_by_group = query.result_count_by_group

      # issue_list(issues) do |issue, level|
      #   if query.grouped? &&
      #        (group = query.group_by_column.value(issue)) != previous_group
      #     pdf.SetFontStyle('B',10)
      #     group_label = group.blank? ? 'None' : group.to_s.dup
      #     group_label << " (#{result_count_by_group[group]})"
      #     pdf.bookmark group_label, 0, -1
      #     pdf.RDMCell(table_width, row_height * 2, group_label, 'LR', 1, 'L')
      #     pdf.SetFontStyle('',8)

      #     totals = totals_by_group.map {|column, total| "#{column.caption}: #{total[group]}"}.join("  ")
      #     if totals.present?
      #       pdf.RDMCell(table_width, row_height, totals, 'LR', 1, 'L')
      #     end
      #     previous_group = group
      #   end

      #   # fetch row values
      #   col_values = fetch_row_values(issue, query, level)

      #   # make new page if it doesn't fit on the current one
      #   base_y     = pdf.get_y
      #   max_height = get_issues_to_pdf_write_cells(pdf, col_values, col_width)
      #   space_left = page_height - base_y - bottom_margin
      #   if max_height > space_left
      #     pdf.add_page("L")
      #     render_table_header(pdf, query, col_width, row_height, table_width)
      #     base_y = pdf.get_y
      #   end

      #   # write the cells on page
      #   issues_to_pdf_write_cells(pdf, col_values, col_width, max_height)
      #   pdf.set_y(base_y + max_height)

      #   if query.has_column?(:description) && issue.description?
      #     pdf.set_x(10)
      #     pdf.set_auto_page_break(true, bottom_margin)
      #     pdf.RDMwriteHTMLCell(0, 5, 10, '', issue.description.to_s, issue.attachments, "LRBT")
      #     pdf.set_auto_page_break(false)
      #   end

      #   if query.has_column?(:last_notes) && issue.last_notes.present?
      #     pdf.set_x(10)
      #     pdf.set_auto_page_break(true, bottom_margin)
      #     pdf.RDMwriteHTMLCell(0, 5, 10, '', issue.last_notes.to_s, [], "LRBT")
      #     pdf.set_auto_page_break(false)
      # end
      # end

      # if issues.size == Setting.issues_export_limit.to_i
      #   pdf.SetFontStyle('B',10)
      #   pdf.RDMCell(0, row_height, '...')
      # end
      # pdf.output
  end

  # def report_issue_to_csv(csv, available_criteria, columns, criteria, periods, hours, level=0)
  #   hours.collect {|h| h[criteria[level]].to_s}.uniq.each do |value|
  #     hours_for_value = select_hours(hours, criteria[level], value)
  #     next if hours_for_value.empty?
  #     row = [''] * level
  #     row << format_criteria_value(available_criteria[criteria[level]], value).to_s
  #     row += [''] * (criteria.length - level - 1)
  #     total = 0
  #     periods.each do |period|
  #       sum = sum_hours(select_hours(hours_for_value, columns, period.to_s))
  #       total += sum
  #       row << (sum > 0 ? sum : '')
  #     end
  #     row << total
  #     csv << row
  #     if criteria.length > level + 1
  #       report_criteria_to_csv(csv, available_criteria, columns, criteria, periods, hours_for_value, level + 1)
  #     end
  #   end
  # end

end