# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: simple_service/v1/simple_retry_api.proto for package 'simple_service.v1'

require 'grpc'
require 'simple_service/v1/simple_retry_api_pb'

module SimpleService
  module V1
    module SimpleRetryAPI
      # A configurable retry api
      class Service

        include ::GRPC::GenericService

        self.marshal_class_method = :encode
        self.unmarshal_class_method = :decode
        self.service_name = 'simple_service.v1.SimpleRetryAPI'

        # request a specific series of responses
        rpc :RetriableAction, ::SimpleService::V1::RetriableActionRequest, ::SimpleService::V1::RetriableActionResponse
      end

      Stub = Service.rpc_stub_class
    end
  end
end
