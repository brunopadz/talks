FROM golang:1.16 AS build

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o consumer .

FROM scratch

COPY --from=build /app/consumer consumer

ENTRYPOINT ["./consumer"]
