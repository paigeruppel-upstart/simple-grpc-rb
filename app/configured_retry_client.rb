#!/usr/bin/env ruby

require "grpc"
require "uuid"
require "json"

gen_files_abs_path = File.join(Dir.pwd, "generated")
$LOAD_PATH.unshift(gen_files_abs_path)

app_path = File.join(Dir.pwd, "app")
$LOAD_PATH.unshift(app_path)

require 'grpc'
require 'constants'
require "simple_service/v1/simple_retry_api_services_pb"

def main
  port = PYTHON_SERVER_PORT
  if ARGV.length >= 1
    port = ARGV[0]
  end

  puts "Will run against port #{port}"
  host = "localhost:#{port}"

  channel_args = {
    "grpc.enable_retries" => 1,
    "grpc.service_config" => JSON.generate(
      methodConfig: [
        name: [{ service: "" }],
        retryPolicy: {
          retryableStatusCodes: %w(FAILED_PRECONDITION ABORTED),
          maxAttempts: 5,
          initialBackoff: "0.1s",
          backoffMultiplier: 2,
          maxBackoff: "1s"
        }
      ]
    )
  }

  stub = ::SimpleService::V1::SimpleRetryAPI::Stub.new(host,
                                                       :this_channel_is_insecure,
                                                       channel_args: channel_args)

  respond_with = [
    { status_code: 9 }, # FAILED_PRECONDITION = 9
    { status_code: 10 } # ABORTED = 10
  ]
  request_id = UUID.generate
  request = ::SimpleService::V1::RetriableActionRequest.new(request_id: request_id, respond_with: respond_with)
  puts "RESPONSE_WITH_NO_MANUAL_RETRY********************"
  response_with_no_manual_retry = stub.retriable_action(request)
  puts response_with_no_manual_retry
end

main


