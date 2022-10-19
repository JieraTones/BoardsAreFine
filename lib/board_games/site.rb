module BoardGames

  class Site < McpEntity
    def identifier_name
      "SITE_UUID"
    end

    def mcp_api_path
      "/api/v2/sites/#{self.identifier}/"
    end

    def friendly_domain
      self["SITE_DOMAIN"] \
        .gsub(/^www\./, "")
        .gsub(/\.com$/, "")
    end

    def basename
      friendly_domain
    end
  end

end
