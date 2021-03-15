# frozen_string_literal: true

require 'caxlsx'

module ShipyardExporter
  module Exportable
    module XlsxExport
      def export_to_xlsx(attributes, titles, decorate: false, output:)
        Rails.logger.info "#{self}: initiating exporting to xlsx"
        ActiveRecord::Base.logger.silence do
          export_result = Axlsx::Package.new.tap do |package|
            package.workbook.tap do |workbook|
              workbook.add_worksheet(name: to_s) do |sheet|
                sheet.add_row titles
                find_each do |resource|
                  resource = resource.decorate if decorate
                  row_data = attributes.map do |attribute|
                    resource.send(:eval, attribute.to_s)
                  rescue StandardError
                    '-'
                  end
                  sheet.add_row row_data
                end
              end
            end
          end
          return export_result.to_stream if output == :stream

          export_result.serialize("#{to_s.pluralize}.xlsx")
        end
      end
    end
  end
end
