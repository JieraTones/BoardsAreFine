module BoardGames

  class ComboBoardFinder
    def self.call(the_board)
      new(the_board).call
    end



    attr_reader :the_board
    def initialize(the_board)
      @the_board = the_board
    end

    def call
      if the_board.combo_board?
        raise ArgumentError, "Can't find combos of a combo board!"
      end
      if the_board.board_number.nil?
        raise ArgumentError, "board doesn't have a board_number???"
      end

      board_hashes = McpTransport.get(
        path:        "/api/v2/boards/",
        field_names: %w[ ID RG_BOARDS ],
      )

      combo_board_ids = board_hashes
        .collect { |e| Candidate.new(e) } \
        .select { |e| e.combo_including?(the_board) }
        .collect(&:id)

      combo_board_ids.collect { |id|
        BoardGames::Board.get_from_mcp_api(
          identifier:  id,
          field_names: the_board.field_names,
        )
      }
    end



    class Candidate
      attr_reader :id, :rg_boards
      def initialize(board_hash)
        @id        = board_hash.fetch("ID")
        @rg_boards = board_hash.fetch("RG_BOARDS")
      end

      def combo_including?(board)
        combo? && includes_board_number?(board.board_number)
      end

      private

      def board_numbers
        @_board_numbers ||= extract_board_numbers
      end

      RG_BOARDS__DEFAULT_VALUE = "[1]"
      def extract_board_numbers
        case rg_boards
        when Array ; rg_boards
        when "[1]" ; [] # default value ==> someone forgot to populate that board
        else       ; raise ArgumentError, "WTF is this value in RG_BOARDS:  #{rg_boards.inspect}"
        end
      end

      def combo?
        1 < board_numbers.length
      end

      def includes_board_number?(board_number)
        board_numbers.include?(board_number)
      end
    end

  end

end
