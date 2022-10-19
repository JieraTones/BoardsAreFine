module BoardGames

  module McpTransport
    extend self



    def get(path:, field_names:)
      response = BoardGames.faraday_connection.get do |req|
        req.url build_url(path, field_names)
        req.headers['Content-Type'] = 'application/json'
      end

      handle_response(response)
    end



    def patch(path:, json_body:)
      response = BoardGames.faraday_connection.patch do |req|
        req.url path
        req.headers['Content-Type'] = 'application/json'
        req.body = json_body
      end

      handle_response(response)
    end



    private

    def build_url(path, field_names)
      url = path
      field_names = Array(field_names).compact.map(&:upcase)
      if !field_names.empty?
        url << "?fields=" << field_names.join(",")
      end
      url
    end

    def handle_response(response)
      case response.status.to_i
      when 200..299
        parse_2xx(response)
      else
        raise <<~EOF
          --
          HTTP GET response:
          status: #{response.status}
          headers: #{response.headers.inspect}
          body:
          #{response.body}
          --
        EOF
      end
    end

    def parse_2xx(response)
      case response.body
      when /^\s*$/ ; nil
      else         ; Array( JSON.parse(response.body) )
      end
    end
  end

end
