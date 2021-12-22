# get latest golang container
FROM golang:1.17.5

# create and set workingfolder
WORKDIR /go/src/

# copy go mod files
COPY go.mod go.sum ./

# download go mods
RUN go mod download

# copy all sourcecode
COPY src/ .

# compile the program
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .


# get latest alpine container
FROM alpine:latest

# add ca-certificates
RUN apk --no-cache add ca-certificates tzdata

# create workdir
WORKDIR /root/

# copy binary from first container
COPY --from=0 /go/src/app .

# expose port 8080
EXPOSE 8080

# run application
CMD ["./app"]