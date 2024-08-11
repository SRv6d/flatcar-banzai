# hadolint global ignore=DL3008
FROM rust:1-slim-bookworm AS build

LABEL org.opencontainers.image.title="electrs"
LABEL org.opencontainers.image.vendor="Marvin Vogt <m@rvinvogt.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
  librocksdb-dev \
  clang \
  make \
  ca-certificates \
  git

WORKDIR /build
RUN git clone https://github.com/Blockstream/electrs .
RUN cargo build --release --locked --features liquid --bin electrs


FROM debian:bookworm-slim AS result
RUN apt-get update && apt-get install --no-install-recommends -y \
  librocksdb-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY --from=build /build/target/release/electrs /app/electrs
ENTRYPOINT ["/app/electrs"]
