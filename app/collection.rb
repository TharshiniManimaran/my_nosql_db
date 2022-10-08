# frozen_string_literal: true

require 'json'

require_relative 'record'

# Implements Record Level Commands on Colections
class Collection
  def initialize(collection)
    @collection = collection
    raise CustomErrors::NotFound, "Collection `#{@collection}` does not exists!" unless Dir.exist?("db/#{@collection}")
  end

  def all
    fetch_records
  end

  def insert(data)
    @record = Record.new(data, @collection)
    add_file_to_directory
    puts 'Record is created successfully!'
    @record
  end

  def find(id)
    file_path = "db/#{@collection}/#{id}.json"
    raise CustomErrors::NotFound, "Record with id #{id} Not Found" unless File.exist?(file_path)

    Record.new(fetch_data(file_path), @collection)
  end

  def find_by(key, value)
    where(key, value, find_one: true).first
  end

  def where(key, value, find_one: false)
    fetch_records(key, value, find_one: find_one)
  end

  def destroy_records(key, value)
    fetch_records(key, value).each do |record|
      file_path = "db/#{@collection}/#{record.id}.json"
      remove_file_from_directory(file_path)
    end
    puts "#{@records.count} Records are deleted successfully!"
  end

  private

  def fetch_data(path)
    JSON.parse(File.read(path))
  rescue StandardError
    raise CustomErrors::InternalServerError, 'An Internal Error Occured'
  end

  def fetch_records(key = nil, value = nil, find_one: false)
    @records = []
    Dir["db/#{@collection}/*"].each do |path|
      data = fetch_data(path)
      if key.nil? && value.nil? || data[key] == value
        @records << Record.new(data, @collection)
        break if find_one
      end
    end
    @records
  end

  def add_file_to_directory
    File.open("db/#{@collection}/#{@record.id}.json", 'w') do |f|
      f.write(@record.data.to_json)
    end
  rescue StandardError
    raise CustomErrors::InternalServerError, 'An Internal Error Occured'
  end

  def remove_file_from_directory(file_path)
    File.delete(file_path)
  rescue StandardError
    raise CustomErrors::InternalServerError, 'An Internal Error Occured'
  end
end
