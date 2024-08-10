FROM debian:bookworm-slim AS base

LABEL org.opencontainers.image.title="electrs"
LABEL org.opencontainers.image.vendor="Marvin Vogt <m@rvinvogt.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
  librocksdb-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


FROM base AS build
ARG VERSION
RUN apt-get update && apt-get install --no-install-recommends -y \
  cargo \
  clang \
  make \
  ca-certificates \
  git

WORKDIR /build
RUN git clone --branch ${VERSION} --single-branch https://github.com/romanz/electrs.git .
ENV ROCKSDB_INCLUDE_DIR=/usr/include
ENV ROCKSDB_LIB_DIR=/usr/lib
RUN cargo build --release --locked


FROM base AS result
COPY --from=build /build/target/release/electrs /app/electrs
ENTRYPOINT ["/app/electrs"]
