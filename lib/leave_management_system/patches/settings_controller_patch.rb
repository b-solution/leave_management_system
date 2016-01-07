module LeaveManagementSystem
  module Patches
    module SettingsControllerPatch
      def self.included base
        base.class_eval do
          include InstanceMethods
          after_filter :generate_yearly_leave_history, :only => [:plugin]
          private :generate_yearly_leave_history
        end
      end

      module InstanceMethods
        def generate_yearly_leave_history
          if request.post? and @plugin.id.to_s == 'leave_management_system'
            LmsYearlyLeaveHistory.generate_yearly_leave_history
          end

        end
      end
    end
  end
end

unless SettingsController.included_modules.include? LeaveManagementSystem::Patches::SettingsControllerPatch
  SettingsController.send :include, LeaveManagementSystem::Patches::SettingsControllerPatch
end