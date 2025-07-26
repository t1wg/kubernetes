FROM debian:latest

# Verify shell exists first
# Install dependencies
WORKDIR /src
RUN apt update -y && apt install -y \
    curl \
    tar \
    git \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Download runner
RUN curl -o actions-runner-linux-x64.tar.gz -L \
    https://github.com/actions/runner/releases/download/v2.326.0/actions-runner-linux-x64-2.326.0.tar.gz \
    && tar xzf actions-runner-linux-x64.tar.gz \
    && rm actions-runner-linux-x64.tar.gz
RUN useradd -ms /bin/bash docker
RUN chown -R docker /src/
RUN ./bin/installdependencies.sh
USER docker
# Configure runner
RUN ["./config.sh","--url", "https://github.com/t1wg/kubernetes" , "--token" , "APQGUDBDHBYDLKW56CUW3DDIQSUZC","--unattended"]

ENTRYPOINT ["./run.sh"]
