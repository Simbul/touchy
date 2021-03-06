module Touchy
  module Model

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def acts_as_touchy(options={})
        send :include, InstanceMethods
        
        after_create  :be_touchy
        after_update  :be_touchy
        after_destroy :be_touchy
      end
    end
    
    module InstanceMethods
      def be_touchy
        unless changed_attributes.has_key?('last_active_at') || !changed?
          current_time = current_time_from_proper_timezone
          current_user = Touchy.current_user
          # TODO refactor
          current_user = current_user.reload if current_user == self
          if current_user
            current_user.class.record_timestamps = false
            current_user.update_attribute(:last_active_at, current_time)
            current_user.class.record_timestamps = true
          end
        end
      end
    end
    
  end
end
