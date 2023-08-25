module TypeFusion
  class Client
    include Singleton

    def post(body)
      Net::HTTP::Post.new(uri).tap do |request|
        request.body = body
        request["Content-Type"] = "application/json"

        if !client.request(request).is_a?(Net::HTTPSuccess)
          puts "Request failed with HTTP status code #{response.code}"
        end
      end
    end

    def uri
      @uri ||= URI(TypeFusion.config.endpoint)
    end

    def client
      Thread.current[:type_fusion_http_client] ||= Net::HTTP.new(uri.host, uri.port).tap do |http|
        http.use_ssl = (uri.scheme == "https")
      end
    end
  end
end
