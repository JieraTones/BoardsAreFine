module BoardGames
class BoardCombiner

  class Field
    def self.list(name)
      new( name, :list_union )
    end

    def self.boolean_true(name)
      new( name, :first_non_default, default: true )
    end

    def self.boolean_false(name)
      new( name, :first_non_default, default: false )
    end

    def self.strict_setting(name)
      list = SETTINGS_LISTS[name]
      new( name, :strictest_setting, strictest_first: list )
    end

    def self.hash(name)
      new( name, :hash_union )
    end

    def self.status_map(name)
      new( name, :status_map )
    end

    def self.text(name)
      new( name, :combine_strings_with_newline )
    end

    def self.lowest_number_wins(name)
      new( name, :min_value )
    end

    def self.hardcode(name, the_value)
      new( name, :hardcode, the_value: the_value )
    end




    attr_accessor :name, :strategy, :kwargs
    def initialize(name, strategy, kwargs = {})
      @name     = name
      @strategy = strategy
      @kwargs   = kwargs
    end

    def populate(combiner)
      combiner.populate name, strategy: strategy, kwargs: kwargs
    end
  end

end
end
