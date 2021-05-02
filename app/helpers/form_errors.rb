module Carpanta
  module Helpers
    class FormErrors
      ERROR_CLASS = "errored".freeze
      SEPARATOR = " ".freeze
      ARIA_DESCRIBED_BY = "aria-describedby".freeze

      def initialize(errors = {})
        @errors = errors
      end

      def with_error_class(id:, html_class:)
        return html_class unless errors?(id)

        [html_class, ERROR_CLASS].join(SEPARATOR)
      end

      def with_aria_entries(id:, attributes:)
        return attributes unless errors?(id)

        attributes.merge("#{ARIA_DESCRIBED_BY}": "#{id}-validation")
      end

      def with_error_entries(id)
        {
          class: "note error",
          id: "#{id}-validation"
        }
      end

      def errors_to_sentence(id)
        errors.fetch(id).to_sentence
      end

      def errors?(id)
        errors.key?(id)
      end

      private

      attr_reader :errors
    end
  end
end
