# frozen_string_literal: true

require_relative 'database'

# Object
class Object
  def db
    @db ||= Database.new
  end
end
