# Simple gRPC Ruby App

This app implements [Simple Retry API](proto/simple_service/v1/simple_retry_api.proto) over gRPC and supports:

- Running a ruby server that serves [an implementation of the above](app/rpc/simple_service/v1/simple_retry_api_controller.rb)
- Running a ruby client with configured retries via channel options
- Running a ruby client with manual retries via channel options

[simple-grpc-py](https://github.com/paigeruppel-upstart/simple-grpc-py) implements the above in python and is meant to be paired with this for cross lang testing.

## Usage

### Install Dependencies
- Requires ruby 3.1.2  
```shell
bundle install
```

### Re-Generate stubs from simple_retry_api.proto
```shell
rake generate_proto_definitions
```

### Serve the API / run the Server

Port defaults to `5555` [RUBY_SERVER_PORT](app/constants.rb)
```shell
bundle exec app/server
``` 

### Run a retry client against the above server

- Client configured with channel args / service_config:  
```shell
bundle exec app/configured_retry_client.rb 5555
```

Client with manual error handling
```shell
bundle exec app/manual_retry_client.rb 5555
```


### Running against Simple gRPC Python App  

(Assumes the python server is running on the default [PYTHON_SERVER_PORT](app/constants.rb))

- Client configured with channel args / service_config:
```shell
bundle exec app/configured_retry_client.rb 7777
```

Client with manual error handling
```shell
bundle exec app/manual_retry_client.rb 7777
```
