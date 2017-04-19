# frozen_string_literal: true
module ElasticIndexer
  class CustomAttachmentSerializer < BaseSerializer
    attributes :name, :label, :url, :content_type, :file_name

    delegate :file, to: :object
    delegate :url, :content_type, to: :file

    delegate :custom_attribute, to: :object
    delegate :name, :label, to: :custom_attribute

    private

    def file_name
      file.file.filename
    end
  end
end