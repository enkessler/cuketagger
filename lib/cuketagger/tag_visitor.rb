module CukeTagger
  module TagVisitor
    attr_accessor :tagger

    def visit_feature(feature)
      @current_feature = feature
      super
    end

    def visit_feature_element(element)
      @current_element = element
      super
      @current_element = nil
    end

    def visit_tags(tags)
      @tagger.process(@current_feature, @current_element, tags.instance_variable_get("@tag_names"))
      super
    end

    private

    def record_tag_occurrences(*args)
      # override to avoid error if options[:include_tags] is nil
    end

  end
end