module Weather
  module Providers
    def self.provider_class_for(name)
      constants
        .map { |c| const_get(c) }
        .select { |klass| klass.is_a?(Class) && klass < Base }
        .find { |klass| klass.provider_name == name } ||
        raise("Unknown provider: #{name.inspect}")
    end
  end
end
