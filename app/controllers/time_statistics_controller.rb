class TimeStatisticsController < ApplicationController
      
  menu_item :time_statistics

  before_filter :authorize, :except => :index
  before_action :find_optional_project, :only => [:index]
  before_action :authorize_global, :only => [:index]
  
  accept_rss_auth :index
  accept_api_auth :index

  rescue_from Query::StatementInvalid, :with => :query_statement_invalid

  helper :issues
  helper :custom_fields
  include CustomFieldsHelper
  helper :queries
  include QueriesHelper
  helper :time_statistics
  include TimeStatisticsHelper

  def index
    retrieve_time_statistics_query
    scope = time_statistics_scope

      if @query.valid?
        @report = RedmineTimeStatistics::Helpers::TimeStatisticsReport.new(@project, scope, @query)

        respond_to do |format|
          format.html { render :layout => !request.xhr? }
          format.api  {  }
          format.atom { render_feed(@report.time_statistics.collect{|x|x.issue}, :title => "#{@project || Setting.app_title}: #{l(:label_issue_plural)}") }
          format.csv  { send_data(report_to_csv(@report, @query, params[:csv]), :type => 'text/csv; header=present', :filename => 'timestatistics.csv') }
          format.pdf  { send_file_headers! :type => 'application/pdf', :filename => 'timestatistics.pdf' }
        end
      else
          respond_to do |format|
              format.html { render :layout => !request.xhr? }
              format.any(:atom, :csv, :pdf) { head 422 }
              format.api { render_validation_errors(@query) }
          end
      end
  rescue ActiveRecord::RecordNotFound
    render_404
  end 

  def update_entries
    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def time_statistics_scope(options={})
    @query.issues(options)
  end

  def retrieve_time_statistics_query
    retrieve_query(TimeStatisticsQuery, false)
  end
          
end  