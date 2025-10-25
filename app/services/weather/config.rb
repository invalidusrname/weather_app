module Weather
  class Config
    attr_accessor :api_key, :provider

    def initialize
      @api_key = nil
      @provider = nil
    end
  end
end
