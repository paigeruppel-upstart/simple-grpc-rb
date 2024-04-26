# frozen_string_literal: true

require "grpc"
require "simple_service/v1/simple_retry_api_services_pb"
require 'logging'

Logging.logger['SimpleRetryApiController'].level = :debug

module SimpleService
  module V1
    class SimpleRetryApiController < SimpleRetryAPI::Service
      # rpc :RetriableAction,
      # @param [::SimpleService::V1::RetriableActionRequest] request
      # @return [::SimpleService::V1::RetriableActionResponse]
      def retriable_action(request, _unused_call)
        logger.info("****************************************")
        request_id = request.request_id
        respond_with_index = get_attempts_for(request_id)

        attempt_number = respond_with_index + 1
        logger.info("received request: \n** request_id: #{request_id}\n** attempt number: #{attempt_number}")

        response = request.respond_with[respond_with_index]
        if response
          status_code = response.status_code
          logger.info("responding with #{status_code}")
          raise GRPC::BadStatus.new_status_exception(status_code, "responding with #{status_code}")
        end

        logger.info("no respond_with found for attempt number  - returning successful response")
        # successful response
        ::SimpleService::V1::RetriableActionResponse.new(request_id: request_id, number_attempts: attempt_number)
      end


      def get_attempts_for(request_id)
        attempt_idx = attempt_map.fetch(request_id, 0)
        attempt_map[request_id] = attempt_idx + 1

        attempt_idx
      end

      def attempt_map
        @attempt_map ||= {}
      end

      def logger
        @logger ||= setup_logger
      end

      def  setup_logger
        logger = Logging.logger[self]

        logger.add_appenders \
          Logging.appenders.stdout,
          Logging.appenders.file('rb.log')

        logger
      end
    end
  end
end