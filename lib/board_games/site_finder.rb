module BoardGames

  class SiteFinder
    def self.find_by_board_ids(*board_ids, field_names:)
      board_ids.flatten!

      site_hashes = McpTransport.get(
        path:        "/api/v2/sites/",
        field_names: %w[ SITE_UUID BOARD ],
      )

      site_uuids = site_hashes
        .select { |e| board_ids.include?(e["BOARD"].to_i) }
        .collect { |e| e["SITE_UUID"] }

      site_uuids.collect { |site_uuid|
        Site.get_from_mcp_api(
          identifier:  site_uuid,
          field_names: field_names,
        )
      }
    end
  end

end
