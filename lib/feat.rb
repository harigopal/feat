module Feat
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Feat::Configuration.new
    yield configuration
  end
end