require 'csv'

module ShipyardExporter
  # rubocop:disable Metrics/BlockLength
  # rubocop:disable Metrics/MethodLength

  # Enable export feature for model. Include module at model to import features
  #
  # Admin.to_csv                                          # export to csv with all attributes
  # Admin.export(format: :csv, attributes: %w[id name])   # export to csv with scoped attributes
  #
  # for customization, define scope and title in model
  #
  # exportable_attributes scope: %w[user.email user_id user.full_name user.phone
  #                                 wearable.wearable_type.name date point weight
  #                                 bmi],
  #                       title: %w[Email UserID Name Phone Wearable Date Steps Weight BMI]
  #
  module Exportable
    class ExportFormatNotSupported < StandardError; end

    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :exportable_scope, :exportable_row_title, :exportable_decorate

      def to_csv
        export(format: :csv)
      end

      def export(format:, attributes: exportable_scope || column_names, row_titles: attributes ? csv_row_title(attributes) : exportable_row_title, decorate: false)
        @exportable_decorate = decorate
        return export_to_csv(attributes, row_titles) if format == :csv

        raise ExportFormatNotSupported, "#{format} export format not supported"
      end

      def exportable(attributes: column_names, titles: nil, decorate: false)
        @exportable_row_title = titles || csv_row_title(attributes)
        @exportable_scope = attributes
        @exportable_decorate = decorate
      end

      private

      def export_to_csv(attributes, titles)
        Rails.logger.info "#{self}: initiating exporting to csv"
        ActiveRecord::Base.logger.silence do
          CSV.generate(headers: true) do |csv|
            csv << titles
            find_each do |resource|
              resource = resource.decorate if @exportable_decorate
              csv << attributes.map do |attribute|
                resource.send(:eval, attribute.to_s)
              rescue StandardError
                '-'
              end
            end
          end
        end
      end

      def csv_row_title(attributes)
        attributes
          .map(&:to_s)
          .map { |attribute| attribute.gsub('.', '_') }
      end
    end
  end

  # rubocop:enable Metrics/BlockLength
  # rubocop:enable Metrics/MethodLength
end
