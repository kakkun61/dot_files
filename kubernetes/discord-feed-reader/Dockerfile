# Build discord-feed-post
FROM --platform=$BUILDPLATFORM golang:1.26 AS discord-feed-post-builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

WORKDIR /workspace

# Clone and build discord-feed-post
RUN git clone https://github.com/kakkun61/discord-feed-post.git . && \
    go mod download

# Set architecture-specific build args
RUN case "$TARGETARCH" in \
      "arm") \
        case "$TARGETVARIANT" in \
          "v7") export GOARM=7 ;; \
          "v6") export GOARM=6 ;; \
          *) export GOARM=5 ;; \
        esac ;; \
    esac && \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o /discord-feed-post .

# Build feed-trigger
FROM --platform=$BUILDPLATFORM golang:1.26 AS feed-trigger-builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

WORKDIR /workspace

# Clone and build feed-trigger
RUN git clone https://github.com/kakkun61/feed-trigger.git . && \
    go mod download

# Set architecture-specific build args
RUN case "$TARGETARCH" in \
      "arm") \
        case "$TARGETVARIANT" in \
          "v7") export GOARM=7 ;; \
          "v6") export GOARM=6 ;; \
          *) export GOARM=5 ;; \
        esac ;; \
    esac && \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o /feed-trigger .

# Final stage
FROM gcr.io/distroless/base-debian12:nonroot

COPY --from=discord-feed-post-builder /discord-feed-post /usr/local/bin/discord-feed-post
COPY --from=feed-trigger-builder /feed-trigger /usr/local/bin/feed-trigger

ENTRYPOINT ["/usr/local/bin/feed-trigger"]
