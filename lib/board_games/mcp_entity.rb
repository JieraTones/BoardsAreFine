module BoardGames

  # FIXME: this class definitely knows TOO MUCH
  # - has settings (this is core)
  # - generates JSON (this is probably innocuous)
  # - loads/updates MCP (on shaky ground)
  # - saves YAML files (wtf absolutely not)
  # - slices
  # - dices
  # - ✂️
  class McpEntity
    def self.get_from_mcp_api(identifier:, field_names: [])
      self.new(identifier: identifier).load_from_mcp(field_names: field_names)
    end

    attr_reader :identifier, :settings
    def initialize(identifier:, settings: {})
      @identifier = identifier
      @settings = BoardGames::Settings.new(settings, ignore: identifier_name)
    end

    extend Forwardable
    def_delegators :settings, :[], :[]=

    def field_names
      settings.keys
    end

    def basename
      "#{self.class.name.downcase}-#{identifier}"
    end

    TRAILING_DOTS = /\.+$/
    LEADING_DOTS  = /^\.+/
    def filename(ext: "yaml")
      [
        basename .strip.sub(TRAILING_DOTS, ""),
        ext      .strip.sub(LEADING_DOTS, ""),
      ].join(".")
    end

    def inspect
      "#<#{self.class}:#{object_id} @identifier=#{identifier.inspect} @old_settings.keys=#{old_settings.keys.sort}>"
    end

    def to_json
      JSON.pretty_generate( identifier_and_settings )
    end

    def json_for_patch
      JSON.pretty_generate( settings.to_h )
    end



    # TODO:  move this API to .get_(board|site)
    # Possible names:
    # - .get_board / .get_site (also s/get/patch/g)
    # - .get(board: 123) / .get(site: "uuid") (also s/get/patch/g)
    #
    # Possible homes::
    # - BoardGames::McpTransport ? Ugly
    # - BoardGames.load_(board|site) ?
    #
    def load_from_mcp(field_names: [])
      data = McpTransport.get( path: mcp_api_path, field_names: field_names )
      raise "unexpected MCP result: #{data.inspect}" if data.length != 1
      @settings = BoardGames::Settings.new(data.first, ignore: identifier_name)
      return self
    end

    def update_in_mcp
      McpTransport.patch( path: mcp_api_path, json_body: json_for_patch )
    end



    YAML_FIELDS = %w[
      PROPERTY_DETAILS
      SEARCH_FIELDS
      SEARCH_FORMS
    ]
    # FIXME: add tests for the following failure modes:
    # - filename is not a reasonable filename (e.g., ".yaml")
    # - contents of the field are nil/blank/empty/whatever
    def save_yamls_to(path)
      YAML_FIELDS.each do |yaml_field|
        data = self[yaml_field]
        wrangler = BoardGames::YAML::FileWrangler.new(root: path, dirname: yaml_field)
        wrangler.create_file name: filename(ext: "yaml"), data: data
      end
    end



    private

    # Note: it's called "identifier and settings" because the identifier should be first
    def identifier_and_settings
      settings.merge( identifier_name => identifier )
    end
  end

end
