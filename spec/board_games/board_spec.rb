# frozen_string_literal: true

RSpec.describe BoardGames::Board do
  let(:board) { described_class.new(identifier: identifier) }
  let(:identifier) { 42 }

  def board_with(settings = {})
    described_class.new(identifier: identifier, settings: settings)
  end

  specify ".identifier_for takes board_number: and returns an MCP ID" do
    with_vcr_cassette("board-identifier_for") do
      identifier = described_class.identifier_for(board_number: 1278)
      expect( identifier ).to eq( 782 )
    end
  end

  describe "settings" do
    it "has an #identifier reader" do
      expect( board.identifier ).to eq( identifier )
    end

    specify "#[] looks up a key in #settings (and is NOT case sensitive)" do
      board = board_with(wibble: "wIbBlE")
      expect( board["WIBBLE"] ).to eq( "wIbBlE" )
      expect( board["wibble"] ).to eq( "wIbBlE" )
    end

    specify "#[]= adds a value to #settings (and is NOT case sensitive)" do
      board = board_with({})
      expect { board["foo"] = "spam" }.to change { board["foo"] }.from( nil ).to( "spam" )
      expect { board["bar"] = "eggs" }.to change { board["bar"] }.from( nil ).to( "eggs" )
    end

    specify "#[]= updates a value in #settings (and is NOT case sensitive)" do
      board = board_with(wibble: "wIbBlE")
      expect { board["WIBBLE"] = "foo" }.to change { board["WIBBLE"] }.to( "foo" )
      expect { board["wibble"] = "bar" }.to change { board["WIBBLE"] }.to( "bar" )
    end
  end

  specify '#to_json returns settings, including {"ID":<MCP ID>}' do
    board = board_with(color: "chartreuse")
    from_json = JSON.parse( board.to_json )
    expect( from_json ).to eq( { "ID" => identifier, "COLOR" => "chartreuse" } )
  end

  specify '#to_json puts the ID first, then alpha sorts all other settings by name' do
    canadian_board = board_with(
      z: "zed",
      a: "eh",
    )
    from_json = JSON.parse( canadian_board.to_json )
    expect( from_json ).to eq(
      {
        "ID" => identifier,
        "A"  => "eh",
        "Z"  => "zed",
      }
    )
  end

  specify '#json_for_patch returns settings WITHOUT {"ID":<MCP ID>}' do
    board = board_with(color: "paisley")
    # b-b-but... paisley's not a color!
    # <batman-slapping-robin.gif>
    # FUNNY TEST DATA KEEPS FUTURE DEVELOPERS ENGAGED!
    from_json = JSON.parse( board.json_for_patch )
    expect( from_json ).to eq( { "COLOR" => "paisley" } )
  end

  describe "a normal (non-combo) board" do
    before do
      board["RG_BOARDS"] = [ 123 ]
    end

    specify "#combo_board? returns false" do
      expect( board.combo_board? ).to be false
    end

    specify "#board_number returns the board number (not identifier)" do
      expect( board.board_number ).to eq( 123 )
    end

    specify "#filename returns '123.yaml'" do
      expect( board.filename ).to eq( "123.yaml" )
    end
  end

  describe "a combo board" do
    before do
      board["RG_BOARDS"] = [ 123, 456 ]
    end

    specify "#combo_board? returns true" do
      expect( board.combo_board? ).to be true
    end

    specify "#board_number returns nil" do
      expect( board.board_number ).to be nil
    end

    specify "#filename returns '123-456.yaml'" do
      expect( board.filename ).to eq( "123-456.yaml" )
    end
  end

  specify "#load_from_mcp" do
    field_names = %w[
      BOARD_NAME
      RG_BOARDS
    ]
    board = described_class.new(identifier: 1902)

    with_vcr_cassette("board/load_from_mcp") do
      board.load_from_mcp(field_names: field_names)
    end

    aggregate_failures do
      expect( board["BOARD_NAME"] ).to eq( "Board (#45, 102) - AUTO COMBO BOARD GENERATOR TEST - HOLD ON TO YOUR ASS" )
      expect( board["RG_BOARDS"]  ).to eq( [2, 45] )
    end
  end

  specify "#update_in_mcp" do
    field_names = %w[
      BOARD_NAME
      RG_BOARDS
    ]
    board = nil # scope hack

    with_vcr_cassette("board/update_in_mcp") do
      board = described_class.get_from_mcp_api(identifier: 1902, field_names: field_names)

      plain = board["BOARD_NAME"]
      spicy = plain + "!!!"

      expect {
        board["BOARD_NAME"] = spicy
        board.update_in_mcp
      }.to change { board["BOARD_NAME"] }.from( plain ).to( spicy )
    end
  end

  let(:temp_dir) { PROJECT_ROOT.join("spec/temp") }

  # NOTE: this behavior will probably move somewhere else
  describe "#save_yamls_to" do
    before { FileUtils.rm_rf temp_dir }
    after  { FileUtils.rm_rf temp_dir }
    before do
      board["RG_BOARDS"]        = [ 123 ]
      board["PROPERTY_DETAILS"] = "not actually property_details"
      board["SEARCH_FIELDS"]    = "not actually search_fields"
      board["SEARCH_FORMS"]     = "not actually search_forms"
    end

    it "creates a property_details folder with a YAML file in it" do
      working_dir = temp_dir.join("property_details")
      creates_yaml_in_folder working_dir, \
        expected_contents: board.settings["PROPERTY_DETAILS"]
    end

    it "creates a search_fields folder with a YAML file in it" do
      working_dir = temp_dir.join("search_fields")
      creates_yaml_in_folder working_dir, \
        expected_contents: board.settings["SEARCH_FIELDS"]
    end

    it "creates a search_forms folder with a YAML file in it" do
      working_dir = temp_dir.join("search_forms")
      creates_yaml_in_folder working_dir, \
        expected_contents: board.settings["SEARCH_FORMS"]
    end

    def creates_yaml_in_folder(working_dir, expected_contents:)
      expect { board.save_yamls_to temp_dir }.to \
        change { working_dir.exist? }
        .from( false ).to( true )
      expect( working_dir.glob("*.yaml").length ).to eq( 1 )

      yaml = first_yaml_file_in( working_dir )
      expect( yaml ).to match( /.*?\.yaml/ )
      expect( yaml ).to_not match( /.*?\.yaml\.yaml/ )
      expect( File.read(yaml) ).to eq( expected_contents )
    end

    def first_yaml_file_in(working_dir)
      working_dir.glob("*.yaml").first.to_s
    end
  end

end

