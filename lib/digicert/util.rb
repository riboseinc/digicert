require "cgi"

module Digicert
  class Util
    def to_query(query)
      build_query(query).flatten.join("&")
    end

    def self.to_query(query)
      new.to_query(query)
    end

    private

    def build_query(value, key = nil)
      if value.is_a?(Hash)
        build_recursive_query(value, key)
      else
        build_escaped_key_value_pair(key, value)
      end
    end

    def build_recursive_query(query, namespace = nil)
      query.map do |key, value|
        query_key = namespace ? "#{namespace}[#{key}]" : key
        build_query(value, query_key)
      end
    end

    def build_escaped_key_value_pair(key, value)
      [CGI.escape(key.to_s), CGI.escape(value.to_s)].join("=")
    end
  end
end
