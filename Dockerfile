FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

FROM alpine:3

RUN adduser -D -s /bin/sh practicum

WORKDIR /app

COPY --from=builder /app/main .

COPY --from=builder /app/tracker.db .

RUN chown -R practicum:practicum /app

USER practicum

CMD ["./main"]
