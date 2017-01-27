require "open-uri"

module Assently
  class CouldNotFetchDocumentError < StandardError
  end

  class Document
    attr_reader :path, :api_key, :api_secret

    def initialize path, filename: nil, api_key: nil, api_secret: nil
      @path = path
      @filename = filename
      @api_key = api_key
      @api_secret = api_secret
    end

    def filename
      @filename || File.basename(path)
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
      begin
        open path, authentication_params
      rescue OpenURI::HTTPError => error
        raise Assently::CouldNotFetchDocumentError.new("Could not get url #{path} (#{error.message})")
      end
    end

    def authentication_params
      if api_key && api_secret
        { http_basic_authentication: [ api_key, api_secret ] }
      else
        {}
      end
    end
  end
end
