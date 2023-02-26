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

    module ClassMethods
      def export user
        local_ability = Ability.new(user)
        # We don't care about the 'cannot' section
        return {class_abilities: local_ability.permissions[:can], object_rules: local_ability.export_rules}
      end
    end
  end
end