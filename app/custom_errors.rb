# frozen_string_literal: true

# CustomErrors
module CustomErrors
  PRE_CONDITION_FAILED         = 412
  NOT_FOUND                    = 404
  UNPROCESSABLE_ENTITY         = 422
  INTERNAL_SERVER_ERROR        = 500

  # ResponseError
  class ResponseError < StandardError
    def initialize(message = nil)
      message.is_a?(Array) ? super(message.first) : super(message)
    end
  end

  class << self
    def error_constants
      constants.each_with_object({}) do |name, hash|
        # Ignore any class constants
        next if (code = CustomErrors.const_get(name)).is_a?(Class)

        hash[name] = code
      end
    end

    def class_name_for_error_name(name)
      name.to_s.split('_').map(&:capitalize).join('')
    end
  end
end

CustomErrors.error_constants.each do |name, code|
  klass = Class.new(CustomErrors::ResponseError)
  klass.send(:define_method, :code) { code }
  CustomErrors.const_set(CustomErrors.class_name_for_error_name(name), klass)
end
