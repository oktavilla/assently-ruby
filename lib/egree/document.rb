require "open-uri"

module Egree
  class CouldNotFetchDocumentError < StandardError
  end

  class Document
    attr_reader :path, :username, :password

    def initialize path, username: nil, password: nil
      @path = path
      @username = username
      @password = password
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
      begin
        open path, authentication_params
      rescue OpenURI::HTTPError => error
        raise Egree::CouldNotFetchDocumentError.new("Could not get url #{path} (#{error.message})")
      end
    end

    def authentication_params
      if username && password
        { http_basic_authentication: [ username, password ] }
      else
        {}
      end
    end
  end
end
