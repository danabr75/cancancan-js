# src: https://stackoverflow.com/questions/16525402/can-i-add-class-methods-and-instance-methods-from-the-same-module
module CanCanCanJs
  module Export
    def self.included(base)
      # base is our target class. Invoke `extend` on it and pass nested module with class methods.
      base.extend ClassMethods
    end

    def export
      {class_abilities: front_end_permissions[:can], object_rules: export_rules}
    end

    def front_end &block
      CanCanCanJs.configuration.start_block_front_end_rules = true
      begin
        block.call
      ensure
        CanCanCanJs.configuration.start_block_front_end_rules = false
      end
    end

    # replicating Ability#permissions method, but for front-end export
    def front_end_permissions
      permissions_list = {
        can: Hash.new { |actions, k1| actions[k1] = Hash.new { |subjects, k2| subjects[k2] = [] } },
        cannot: Hash.new { |actions, k1| actions[k1] = Hash.new { |subjects, k2| subjects[k2] = [] } }
      }
      usable_rules_list = front_end_rules
      if CanCanCanJs.configuration.export_all_back_end_rules
        usable_rules_list = rules
      end
      usable_rules_list.each { |rule| extract_rule_in_permissions(permissions_list, rule) }
      permissions_list
    end

    def export_rules
      new_list = {}
      usable_rules_list = front_end_rules
      if CanCanCanJs.configuration.export_all_back_end_rules
        usable_rules_list = rules
      end
      usable_rules_list.each do |rule|
        # init subjects if necessary
        rule.subjects.each do |subject|
          # subject_key is Class name as sym.
          subject_key = subject.is_a?(Symbol) ? subject : subject.name.to_sym
          new_list[subject_key] ||= {}
          # init actions
          rule.actions.each do |action|
            # Change must match at least one conditional group in order to auth the action, or if condition_groups are nil
            new_list[subject_key][action] ||= {condition_groups: nil}

            new_list[subject_key][action][:condition_groups] ||= []
            if rule.conditions.present?
              new_list[subject_key][action][:condition_groups] << rule.conditions
            else
              # if no conditions, then the action SHOULD be allowed!
              # - without this line, can-lines without conditions would not be exportable to the front-end
              new_list[subject_key][action][:condition_groups] << nil
            end
            if action == :update || action == :create
              klass = subject_key.to_s.constantize
              new_list[subject_key][action][:whitelist_attribs] = permitted_attributes(action, klass)
            end
          end
        end
      end
      return new_list
    end

    module ClassMethods
      def export user
        local_ability = Ability.new(user)
        # We don't care about the 'cannot' section
        return {class_abilities: local_ability.front_end_permissions[:can], object_rules: local_ability.export_rules}
      end
    end
  end
end