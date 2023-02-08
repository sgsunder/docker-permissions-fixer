FROM rust:alpine as builder
# NOTE: need to use alpine to ensure binary is 100% statically linked
WORKDIR /opt/app
COPY Cargo.toml /opt/app/Cargo.toml
COPY src/main.rs /opt/app/src/main.rs
RUN cargo build --release

FROM scratch
COPY --from=builder /opt/app/target/release/docker-permissions-fixer /.init
ENTRYPOINT [ "/.init" ]

ARG BUILD_DATE="Unknown"
ARG SOURCE_COMMIT="Unknown"
LABEL \
    maintainer="" \
    org.opencontainers.image.title="ghcr.io/sgsunder/docker-permissions-fixer" \
    org.opencontainers.image.url="https://github.com/sgsunder/docker-permissions-fixer" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.source="https://github.com/sgsunder/docker-permissions-fixer" \
    org.opencontainers.image.revision="${SOURCE_COMMIT}" \
    org.opencontainers.image.licenses="MIT"