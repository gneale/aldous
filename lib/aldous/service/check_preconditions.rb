module Aldous
  module Service
    class CheckPreconditions
      attr_reader :preconditions

      def initialize(preconditions)
        @preconditions = preconditions
      end

      def perform
        preconditions.each do |precondition|
          ensure_precondition_includes_precondition_module(precondition)
          precondition_result = precondition.check
          unless precondition_result.success?
            specific_result_class = precondition_failure_result(precondition) || ::Service::PreconditionFailureResult
            return specific_result_class.new(precondition_failure_result_options(precondition, precondition_result))
          end
        end
        ::Service::SuccessResult.new
      end

      private

      def ensure_precondition_includes_precondition_module(precondition)
        unless precondition.kind_of?(Controller::Precondition)
          raise "Precondition #{precondition.class} must include the Controller::Precondition module"
        end
      end

      def precondition_failure_result(precondition)
        failure_result_class_name = "#{precondition.class.name.split('::').last}FailureResult"
        ::Service.const_get(failure_result_class_name)
      rescue
        nil
      end

      def precondition_failure_result_options(precondition, precondition_result)
        precondition_result._options.merge(cause: precondition_result)
      end
    end
  end
end
