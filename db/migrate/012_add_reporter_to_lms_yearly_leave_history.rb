class AddReporterToLmsYearlyLeaveHistory < ActiveRecord::Migration
  def change
    add_column :lms_yearly_leave_histories, :reporter, :integer
  end
end
