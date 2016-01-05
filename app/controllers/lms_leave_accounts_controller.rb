class LmsLeaveAccountsController < ApplicationController
  unloadable
  include LeaveManagementSystem::Controller

  before_filter :lms_authorize
  before_filter :find_current_year_settings, :only => [:index]
  before_filter :find_leave_types, :only => [:index]

  def index
    @leave_accounts = LmsYearlyLeaveHistory.joins(:employee, :lms_yearly_setting)
                          .where("year = YEAR(NOW())")
                          .select( "CONCAT(users.firstname, ' ', users.lastname) AS emp_name, #{LmsYearlyLeaveHistory.table_name}.*")
                          .order("emp_name ASC")
  end

  def create
  end

  def update
    yearly_leave_history = LmsYearlyLeaveHistory.find params[:id]
    status, data, error = 200, {}, []
    unless yearly_leave_history.update_attributes leave_account_params
      status = 406
      error = yearly_leave_history.errors.full_messages
    else
      params[:leave_account].each do |lt, days|
        data.merge! lt => yearly_leave_history.send(lt)
      end
    end
    render :json => {:status => status, :data => data, :error => error}
  end

  private
  def leave_account_params
    # params.require(:leave_account).permit( :user_id , :lms_yearly_setting_id , :tot_carry_forward , :total_leaves , :tot_wfh , :created_at , :updated_at , :tot_casualleave , :tot_sickleave , :tot_privilegeleave , :tot_compoff)
    params.require(:leave_account).permit!
  end
  def permit!
    each_pair do |key, value|
      convert_hashes_to_parameters(key, value)
      self[key].permit! if self[key].respond_to? :permit!
    end

    @permitted = true
    self
  end
end
