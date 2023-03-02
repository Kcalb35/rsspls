FROM lukemathwalker/cargo-chef:latest-rust-1 AS chef
WORKDIR app
COPY config /usr/local/cargo

FROM chef AS planner
COPY . .
RUN cargo chef prepare

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
RUN cargo build --release

FROM debian:bullseye-slim as runtime
WORKDIR app
RUN apt-get update & apt-get install -y extra-runtime-dependencies & rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/rsspls /usr/local/bin/rsspls
COPY ./entry.sh .
VOLUME ["/app/feeds"]
ENTRYPOINT ["./entry.sh"]