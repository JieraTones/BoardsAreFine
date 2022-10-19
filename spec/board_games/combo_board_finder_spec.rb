require "spec_helper"

RSpec.describe BoardGames::ComboBoardFinder do

  describe ".call" do
    let(:board) {
      with_vcr_cassette("combo_board_finder-call") do
        BoardGames::Board.get_from_mcp_api(
          identifier: 408,
          field_names: field_names,
        )
      end
    }
    let(:field_names) {
      %w[
        BOARD_NAME
        RG_BOARDS
        PROPERTY_DETAILS
        SEARCH_FIELDS
        SEARCH_FORMS
      ]
    }

    def invoke!
      with_vcr_cassette("combo_board_finder-call") do
        return described_class.call(board)
      end
    end

    it "takes a board and returns an array of all combo boards that reference that board" do
      expect( board["RG_BOARDS"] ).to eq( [ 45 ] )

      combos = invoke!
      expect( combos.length ).to be > 1
      expect( combos.first ).to be_instance_of(BoardGames::Board)
      expect( combos.first["RG_BOARDS"] ).to include( board.board_number )
    end

    specify "the original board is NOT included in the results" do
      combos = invoke!
      expect( combos.map(&:identifier).sort ).to_not include( board.identifier )
    end

    specify "the boards in the results all have the same field_names as the board we passed in" do
      combos = invoke!

      unique_list = combos.collect(&:field_names).uniq
      expect( unique_list.length ).to eq( 1 )                 # all the same...
      expect( unique_list.first  ).to eq( board.field_names ) # ...as the one we passed in
    end

    it "asplodes if the_board.combo_board? is true" do
      allow( board ).to receive( :combo_board? ).and_return( true )
      expect { invoke! }.to raise_error( ArgumentError, /can't find combos of a combo board/i )
    end

    it "asplodes if the_board.board_number is nil" do
      allow( board ).to receive( :board_number ).and_return( nil )
      expect { invoke! }.to raise_error( ArgumentError, /board doesn't have a board_number/i )
    end
  end

end
