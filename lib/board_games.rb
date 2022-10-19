# frozen_string_literal: true

# ruby standard lib
require "yaml"
require "fileutils"

# gems
require "faraday"

# our code
require_relative "board_games/mcp_entity" # before board/site

require_relative "board_games/board"
require_relative "board_games/board_combiner"
require_relative "board_games/combine_values"
require_relative "board_games/combo_board_finder"
require_relative "board_games/mcp_transport"
require_relative "board_games/settings"
require_relative "board_games/site"
require_relative "board_games/site_finder"
require_relative "board_games/yaml"
require_relative "board_games/yamls"

module BoardGames
  extend self

  MCP_URL          = "https://mcp-api.realgeeks.com"
  MCP_STAGING_URL  = "https://mcp-api.stg.realgeeks.com"
  MCP_API_PASSWORD = "a98sdfyu9pasuifdujasdflahsdf98as0oifuasdflkn"

  def faraday_connection(url: MCP_URL)
    Faraday.new(url) do |conn|
      conn.adapter Faraday.default_adapter
      conn.request :authorization, :basic, "", MCP_API_PASSWORD
    end
  end

end
