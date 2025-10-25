module Weather
  class Config
    attr_accessor :api_key

    def initialize
      @api_key = nil
    end
  end
end
