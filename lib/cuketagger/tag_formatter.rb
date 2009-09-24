module CukeTagger
  module TagFormatter
    attr_accessor :tagger

    def before_feature(feature)
      @__current_feature = feature
      super
    end

    def before_feature_element(element)
      @__current_element = element
      super
    end
    
    def after_feature_element(element)
      @__current_element = nil
      super
    end

    def before_tags(tags)
      @tagger.process(@__current_feature, @__current_element, tags.instance_variable_get("@tag_names"))
    end

    private

    def record_tag_occurrences(*args)
      # override to avoid error if options[:include_tags] is nil
    end
    
    def print_summary(*args)
      # override
    end
    
  end
end