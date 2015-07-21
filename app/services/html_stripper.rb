class HTMLStripper
  include ActionView::Helpers::SanitizeHelper # extend does not work

  class << self
    def strip(html)
      stripper.strip_tags(html)
    end

    def sanitize(html)
      stripper.sanitize(html)
    end

    protected
    def stripper
      @stripper ||= new
    end
  end
end
