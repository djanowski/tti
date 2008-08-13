module Configurable
  def self.included(base)
    base.cattr_accessor :configuration
    
    base.instance_eval(<<-EOS)
    def self.configure
      self.configuration ||= Configuration.new(self)
      yield(configuration)
      configuration
    end
    EOS
  end

  class Configuration
    def initialize(configurable)
      @configurable = configurable
      @config = {}
    end

    def method_missing(method_id, *args, &block)
      is_assignment = method_id.to_s[-1, 1] == '='
      key = is_assignment ? method_id.to_s[0..-2].to_sym : method_id

      if is_assignment
        @config[key] = args.first
      else
        @config[key]
      end
    end

    def default!
      @default_config = @config.dup
    end

    def reset!
      @config = @default_config ? @default_config.dup : {}
    end
  end

  def config
    self.class.configuration ||= Configuration.new(self)
  end
end
