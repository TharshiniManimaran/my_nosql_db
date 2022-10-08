# frozen_string_literal: true

require_relative 'collection'
require_relative 'custom_errors'

# Database
class Database
  include CustomErrors

  def initialize
    puts "Welcome to my NoSql DB! \n Use `help` to view the list of available commands"
  end

  def help
    puts "List of commands::\n #{collection_commands}\n #{record_commands}"
  end

  def create_collection(collection_name)
    path = "db/#{collection_name}"
    raise CustomErrors::PreConditionFailed, "Collection `#{collection_name}` already exists!" if Dir.exist?(path)

    add_directory(path)
    puts "Collection `#{collection_name}` is created successfully!"
  end

  def list_collections
    Dir.entries('db').reject { |entry| ['.', '..', '.gitkeep'].include?(entry) }
  end

  def drop_collection(collection_name)
    path = "db/#{collection_name}"
    raise CustomErrors::NotFound, "Collection `#{collection_name}` does not exists!" unless Dir.exist?(path)

    remove_directory(path)
    puts "Collection `#{collection_name}` is dropped successfully!"
  end

  private

  def collection_commands
    " Commands on Collections:
        Create a new Collection          :create_collection(collection)
        List all Collections             :list_collections
        Drop a Collection                :drop_collection(collection)"
  end

  def record_commands
    " Commands on Records:
        List all Records                 :all
        Find a Record by Key-Value       :find_by(key, value)
        Find all Records by Key-Value    :where(key, value)
        Find a Field Value in a Record   :find(id).select(key) || :find_by(key, value).select(key)
        Find a Record by id              :find(id)
        Add a Record                     :insert(record)
        Delete a Record                  :find(id).destroy || :find_by(key, value).destroy
        Delete a Record by Key-Value     :destroy_records(key, value)"
  end

  def add_directory(path)
    Dir.mkdir(path)
  rescue StandardError
    raise CustomErrors::InternalServerError, 'An Internal Error Occured'
  end

  def remove_directory(path)
    FileUtils.remove_dir(path)
  rescue StandardError
    raise CustomErrors::InternalServerError, 'An Internal Error Occured'
  end

  def method_missing(method_name)
    path = "db/#{method_name}"
    raise CustomErrors::NotFound, "Collection `#{method_name}` does not exists!" if respond_to_missing?(path)

    ::Collection.new(method_name)
  end

  def respond_to_missing?(method_name)
    !Dir.exist?(method_name)
  end
end
