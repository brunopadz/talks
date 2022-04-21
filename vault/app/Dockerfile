FROM golang:1.16 AS build

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o api .

FROM scratch

COPY --from=build /app/api api

EXPOSE 3000

ENTRYPOINT ["./api"]
