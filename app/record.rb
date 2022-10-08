# frozen_string_literal: true

require 'securerandom'

# Implements Commands on a Colection's Record
class Record
  attr_reader :data

  def initialize(data, collection)
    @data = data
    @collection = collection
    raise CustomErrors::UnprocessableEntity, 'Invalid Input' unless data.is_a?(Hash)
    return unless @data['_id'].nil?

    id = SecureRandom.uuid
    @data = { '_id' => id }.merge!(data)
  end

  def id
    @data['_id']
  end

  def select(key)
    @data[key]
  end

  def destroy
    file_path = "db/#{@collection}/#{id}.json"
    raise CustomErrors::NotFound, "Record with id #{id} Not Found" unless File.exist?(file_path)

    remove_file_from_directory(file_path)
    puts 'Record is deleted successfully!'
  end

  private

  def remove_file_from_directory(file_path)
    File.delete(file_path)
  rescue StandardError
    raise CustomErrors::InternalServerError, 'An Internal Error Occured'
  end
end
