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
  port = RUBY_SERVER_PORT
  if ARGV.length >= 1
    port = ARGV[0]
  end

  puts "Will run against port #{port}"
  host = "localhost:#{port}"

  stub = ::SimpleService::V1::SimpleRetryAPI::Stub.new(host,
                                                       :this_channel_is_insecure)

  # ensures that the underlying impl operates as expected
  # - the following logic should succeed on its third attempt
  #   # FAILED_PRECONDITION = 9
  #   # ABORTED = 10
  respond_with = [
    { status_code: 9 },
    { status_code: 10 }
  ]
  request_id = UUID.generate
  request = ::SimpleService::V1::RetriableActionRequest.new(request_id: request_id, respond_with: respond_with)
  attempts = 0
  while attempts <= respond_with.size
    attempts += 1
    puts "Attempt number: #{attempts}"

    begin
      response = stub.retriable_action(request)
      puts "Manual retry client received: #{response}"
    rescue GRPC::BadStatus => e
      puts "RECEIVED ERROR FROM SERVER: #{e.code}"
    end
  end
end

main