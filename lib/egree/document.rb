require "open-uri"

module Egree
  class Document
    attr_reader :path

    def initialize path
      @path = path
    end

    def filename
      File.basename path
    end

    def size
      file.size
    end

    def content_type
      "application/pdf"
    end

    def data
      Base64.encode64 file_contents
    end

    def add_form_field form_field
      self.form_fields << form_field
    end

    def form_fields
      @form_fields ||= []
    end

    private

    def file_contents
      file.read
    end

    def file
      open path
    end
  end
end
