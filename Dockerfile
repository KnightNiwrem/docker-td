FROM ubuntu:18.04 AS builder

# Install dependencies
WORKDIR /
RUN apt-get -y update && \
    apt-get install -y git && \
    git clone https://github.com/tdlib/td.git

# Checkout to the latest release
WORKDIR /td
RUN git checkout $(git describe --abbrev=0 --tags)

FROM builder as compiler

# Install dependencies
WORKDIR /
RUN apt-get -y update && \
    apt-get install -y build-essential ccache cmake curl git gperf g++ libreadline-dev libssl-dev zlib1g-dev
COPY --from=builder /td .

# Build tdlib
WORKDIR /td/build
RUN cmake -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build .

# Run script
CMD ["/bin/bash"]
