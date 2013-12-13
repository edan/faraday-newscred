require 'faraday'
module Faraday

  class Newscred < Faraday::Middleware
    VALID_API_PARAMS  = [:access_key, :format, :pagesize, :offset, :fields, :from_date, :to_date, :query].freeze
    VALID_FORMATS     = [:xml, :json, :rss].freeze
    MAX_PAGESIZE      = 999.freeze

    attr_reader :newscred_params
    
    def initialize(app, newscred_params = {})
      super(app)
      assert_valid_options!(newscred_params)

      raise ArgumentError, 'access_key can not be nil, please pass in access_key in options hash' if newscred_params[:access_key].nil?
      @newscred_params = newscred_params
    end

    #passed in options trump any existing query string
    def call(env)
      env[:url].query = Faraday::Utils.build_query(newscred_params)

      @app.call env
    end

    def assert_valid_options!(options)
      options.each_key do |key|
        unless VALID_API_PARAMS.include?(key)
          raise ArgumentError.new("Unknown api params: #{key}. Valid api params are: [#{VALID_API_PARAMS.join(', ')}]")
        end
      end
    end

  end
end
