# frozen_string_literal: true

require 'active_support'
require 'shipyard_exporter/exportable/csv_export'
require 'shipyard_exporter/exportable/xlsx_export'

module ShipyardExporter
  module Exportable
    class ExportFormatNotSupported < StandardError; end

    extend ActiveSupport::Concern

    class_methods do
      include Exportable::CsvExport
      include Exportable::XlsxExport
      attr_accessor :exportable_scope, :exportable_row_title, :exportable_decorate

      def to_csv
        export(format: :csv)
      end

      def to_xlsx
        export(format: :xlsx)
      end

      def export(format:, attributes: exportable_scope || column_names, row_titles: attributes ? define_row_titles_from(attributes) : exportable_row_title, decorate: false, output: :stream)
        @exportable_decorate ||= decorate
        return export_to_csv(attributes, row_titles, decorate: @exportable_decorate) if format == :csv
        return export_to_xlsx(attributes, row_titles, decorate: @exportable_decorate, output: output) if format == :xlsx

        raise ExportFormatNotSupported, "#{format} export format not supported"
      end

      def exportable(attributes: column_names, titles: nil, decorate: false)
        @exportable_row_title = titles || define_row_titles_from(attributes)
        @exportable_scope = attributes
        @exportable_decorate = decorate
      end

      private

      def define_row_titles_from(attributes)
        attributes
          .map(&:to_s)
          .map { |attribute| attribute.gsub('.', '_') }
      end
    end
  end
end
