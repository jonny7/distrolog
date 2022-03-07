CONFIG_PATH=${HOME}/.distrolog/

.PHONY: init
init:
	mkdir -p ${CONFIG_PATH}

.PHONY: deinit
deinit:
	rm -rf ${CONFIG_PATH}

.PHONY: gencert
gencert:
	cfssl gencert \
			-initca test/ca-csr.json | cfssljson -bare ca
	cfssl gencert \
			-ca=ca.pem \
			-ca-key=ca-key.pem \
			-config=test/ca-config.json \
			-profile=server \
			test/server-csr.json | cfssljson -bare server
	cfssl gencert \
				-ca=ca.pem \
				-ca-key=ca-key.pem \
				-config=test/ca-config.json \
				-profile=client \
				test/client-csr.json | cfssljson -bare client
	mv *.pem *csr ${CONFIG_PATH}

.PHONT: compile
compile:
#   You need both: protoc-gen-go & protoc-gen-go-grpc binaries
# 	Also note the go_out and go-grpc_out. You need one for serialization and one for client/server stubs
	protoc api/v1/*.proto  \
			--go_out=. \
			--go_opt=paths=source_relative \
			--go-grpc_out=. \
			--go-grpc_opt=paths=source_relative \
			--proto_path=.

.PHONY: test
test:
	go test -race ./...