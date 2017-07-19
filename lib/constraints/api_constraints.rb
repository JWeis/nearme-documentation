# frozen_string_literal: true
module Constraints
  class ApiConstraints
    def initialize(options)
      @version = options[:version]
      @default = options[:default]
    end

    def matches?(req)
      @default || req.headers['Accept']&.include?("application/vnd.nearme.v#{@version}+json")
    end
  end
end