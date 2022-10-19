module BoardGames

  class Settings

    def initialize(hash, ignore: [])
      @data = normalize_keys(hash, ignore: [])
    end

    extend Forwardable
    def_delegators :@data, :keys, :to_h, :merge, :clear

    def [](setting_name)
      key = key_for_name(setting_name)
      @data[key]
    end

    def []=(setting_name, value)
      key = key_for_name(setting_name)
      @data[key] = value
    end

    private

    def key_for_name(setting_name)
      setting_name.upcase.to_s
    end

    # FIXME: both of these are presentation-level concerns;
    # can they be pulled back up into McpEntity?
    #
    # For clarity and readability:
    # - ignore some provided values (e.g., "ID" or "SITE_UUID")
    # - sort remaining settings alphabetically by key
    def normalize_keys(hash, ignore: [])
      keys_to_ignore = Array(ignore).map( &method(:key_for_name) )
      sorted_pairs = hash \
        .map { |(k,v)| [ key_for_name(k), v ] }
        .reject { |(k,_)| keys_to_ignore.include?(k) }
        .sort

      Hash[ sorted_pairs ]
    end
  end

end
