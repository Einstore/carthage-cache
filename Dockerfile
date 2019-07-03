FROM einstore/vapor-swift as builder

WORKDIR /app
COPY . /app

ARG CONFIGURATION="release"

RUN swift build --configuration ${CONFIGURATION} --product carthage-server

# ------------------------------------------------------------------------------

FROM swift:slim

ARG CONFIGURATION="release"

WORKDIR /app
COPY --from=builder /app/.build/${CONFIGURATION}/carthage-server /app

ENTRYPOINT ["/app/carthage-server"]
CMD ["serve", "--hostname", "0.0.0.0", "--port", "8080"]
