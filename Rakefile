# frozen_string_literal: true

desc "generate rb files from proto definition at proto"
task :generate_proto_definitions do
  system "bundle exec grpc_tools_ruby_protoc -I proto " \
           "--ruby_out=generated " \
           "--grpc_out=generated " \
           "proto/simple_service/v1/simple_retry_api.proto"
end