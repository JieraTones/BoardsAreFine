module BoardGames

  class Board < McpEntity
    def self.identifier_for(board_number:)
      board_hashes = McpTransport.get(
        path:        "/api/v2/boards/",
        field_names: %w[ ID RG_BOARDS ],
      )
      h = board_hashes.detect { |e| e["RG_BOARDS"] == [board_number.to_i] }
      h && h["ID"]
    end

    def identifier_name
      "ID"
    end

    def mcp_api_path
      "/api/v2/boards/#{self.identifier}/"
    end

    def board_numbers
      Array(self["RG_BOARDS"]).compact.map(&:to_i).reject { |e| e < 1 }.sort.uniq
    end

    def board_number
      return nil if combo_board?
      board_numbers.first
    end

    def combo_board?
      board_numbers.length > 1
    end

    def basename
      board_numbers.sort.join("-")
    end
  end

end

