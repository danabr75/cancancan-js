class Ability
  # ex: Ability.export(u)
  def self.export user
    local_ability = Ability.new(user)
    # We don't care about the 'cannot' section
    return {class_abilities: local_ability.permissions[:can], object_rules: local_ability.export_rules}
  end
  def export
    {class_abilities: permissions[:can], object_rules: export_rules}
  end
end