module CanCanCanJs
  class Configuration
    # CanCanCanJs.configuration.start_block_front_end_rules
    attr_accessor :start_block_front_end_rules
    # CanCanCanJs.configuration.export_all_back_end_rules
    attr_accessor :export_all_back_end_rules

    def initialize
      @start_block_front_end_rules = false
      @export_all_back_end_rules = false
    end
  end
end