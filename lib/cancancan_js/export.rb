# src: https://stackoverflow.com/questions/16525402/can-i-add-class-methods-and-instance-methods-from-the-same-module
module CanCanCanJs
  module Export
    def self.included(base)
      # base is our target class. Invoke `extend` on it and pass nested module with class methods.
      base.extend ClassMethods
    end

    def export
      {class_abilities: permissions[:can], object_rules: export_rules}
    end

    # Only works with SQL rules, does not support `if` blocks
    # Associational data has to be present on object to work. Best to work with attribute data.
    #   i.e. when possible 
    #     Use: `can [:update], Resource, account_id: [1,2,3]`
    #     Not: `can [:update], Resource, accounts: { id [1,2,3] }`
    # There might be association name differences between the back-end and front-end.
    #   i.e. a user's `contact` might be `contact_attributes` on the front-end. Nothing to be done
    #   right now. Can try using alias conversions here in the future. aliases = {user: {contacts: :contact_attributes}}
    def export_rules
      new_list = {}
      rules.each do |rule|
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
        return {class_abilities: local_ability.permissions[:can], object_rules: local_ability.export_rules}
      end
    end
  end
end