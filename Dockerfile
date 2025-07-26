FROM debian:latest

# Verify shell exists first
# Install dependencies
WORKDIR /src
RUN apt update -y && apt install -y \
    curl \
    tar \
    git \
    jq
RUN apt install -y ca-certificates curl
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update -y
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Download runner
RUN curl -o actions-runner-linux-x64.tar.gz -L \
    https://github.com/actions/runner/releases/download/v2.326.0/actions-runner-linux-x64-2.326.0.tar.gz \
    && tar xzf actions-runner-linux-x64.tar.gz \
    && rm actions-runner-linux-x64.tar.gz
RUN useradd -ms /bin/bash -g docker docker
RUN chown -R docker /etc/init.d/docker
RUN chown -R docker /src/
RUN ./bin/installdependencies.sh
USER docker
# Configure runner
RUN ["./config.sh","--url", "https://github.com/t1wg/kubernetes" , "--token" , "APQGUDGTL7OHMOTQYIRZBN3IQTEVW","--unattended"]
ENTRYPOINT ["./run.sh"]
