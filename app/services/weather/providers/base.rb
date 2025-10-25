module Weather
  module Providers
    class Base
      attr_reader :api_key

      def initialize(api_key)
        @api_key = api_key
      end

      def self.provider_name
        name.demodulize.underscore
      end

      def provider_name
        self.class.provider_name
      end

      def query(zip)
        raise NotImplementedError
      end

      def self.convert_to_forecast(data)
        raise NotImplementedError
      end
    end
  end
end
