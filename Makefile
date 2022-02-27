compile:
#   You need both: protoc-gen-go & protoc-gen-go-grpc binaries
# 	Also note the go_out and go-grpc_out. You need one for serialization and one for client/server stubs
	protoc api/v1/*.proto  \
			--go_out=. \
			--go_opt=paths=source_relative \
			--go-grpc_out=. \
			--go-grpc_opt=paths=source_relative \
			--proto_path=.

test:
	go test -race ./...