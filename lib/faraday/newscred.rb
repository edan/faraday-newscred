require 'faraday'
module Faraday

  class Newscred < Faraday::Middleware
    VALID_API_PARAMS  = [:access_key, :format, :pagesize, :offset, :fields]
    VALID_FORMATS     = [:xml, :json, :rss]
    MAX_PAGESIZE      = 999

    attr_reader :newscred_params
    
    def initialize(app, newscred_params = {})
      super(app)
      assert_valid_options!(newscred_params)

      raise ArgumentError, "access_key can't be nil" if newscred_params[:access_key].nil?
      @newscred_params = newscred_params
    end

    def call(env)
      params = Faraday::Utils.parse_query(env[:url].query).merge!(newscred_params)
      env[:url].query = Faraday::Utils.build_query(params)

      @app.call env
    end

    def assert_valid_options!(options)
      options.each_key do |key|
        unless VALID_API_PARAMS.include?(key)
          raise ArgumentError.new("Unknown option: #{key}. Valid options are :#{VALID_OPTIONS.join(', ')}")
        end
      end
    end

  end
end
