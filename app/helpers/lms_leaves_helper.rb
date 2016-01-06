module LmsLeavesHelper
  def leaves_to_be_detected tot_leaves, ded_leaves, nol
    if nol < (tot_leaves - ded_leaves)
      (0..nol).step(0.5)
    else
      (0..(tot_leaves - ded_leaves)).step(0.5)
    end
  end
  
  def available_leaves tot_leaves, ded_leaves
    tot_leaves - ded_leaves
  end
  
  def reporting_managers
    current_user = Employee.current
    current_year_leave_history = current_user.current_year_leave_history
    if current_year_leave_history.reporter.to_i.zero?
      LeaveManagementSystem.active_employees_with_role(LeaveManagementSystem::ROLES[:ar]).select {|manager| manager != current_user}
    else
      manager = User.find current_year_leave_history.reporter.to_i
      LeaveManagementSystem.active_employees_with_role(LeaveManagementSystem::ROLES[:ar]).select {|ma| ma.id == manager.id}
    end
  end
end
