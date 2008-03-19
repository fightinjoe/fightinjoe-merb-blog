module Merb
  module ControllerExceptions
    class InternalServerError < Merb::ControllerExceptions::ServerError
      def name
        @exception ? @exception.class.name.to_s.snake_case : super
      end
    end
  end
end