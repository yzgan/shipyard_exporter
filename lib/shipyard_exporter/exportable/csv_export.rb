# frozen_string_literal: true

require 'csv'

module ShipyardExporter
  module Exportable
    module CsvExport
      def export_to_csv(attributes, titles, decorate: false)
        Rails.logger.info "#{self}: initiating exporting to csv"
        ActiveRecord::Base.logger.silence do
          CSV.generate(headers: true) do |csv|
            csv << titles
            find_each do |resource|
              resource = resource.decorate if decorate
              csv << attributes.map do |attribute|
                resource.send(:eval, attribute.to_s)
              rescue StandardError
                '-'
              end
            end
          end
        end
      end
    end
  end
end
