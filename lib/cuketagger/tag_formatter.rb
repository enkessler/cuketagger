module CukeTagger
  module TagFormatter
    attr_accessor :tagger

    def feature(feature)
      @tagger.process @uri, feature
      super
    end

    def scenario_outline(scenario_outline)
      @tagger.process @uri, scenario_outline
      super
    end

    def scenario(scenario)
      @tagger.process @uri, scenario
      super
    end

  end
end