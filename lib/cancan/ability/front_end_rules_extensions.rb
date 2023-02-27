module FrontEndRulesExtensions
  protected
  def front_end_rules
    @front_end_rules ||= []
  end
  private
  def add_rule(rule)
    if CanCanCanJs.configuration.start_block_front_end_rules
      front_end_rules << rule
    end
    super(rule)
  end
end