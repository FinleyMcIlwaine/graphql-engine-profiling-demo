ARG GRAPHQL_ENGINE_BASE_IMAGE_TAG="fa4c8eb725a7c89f86120b153d091c904251e58fb9861e2217d8e50eeabf04ba.ubuntu.arm64"
FROM hasura/graphql-engine-base:${GRAPHQL_ENGINE_BASE_IMAGE_TAG}

###############################################################################
# Install dependencies and tooling
###############################################################################

RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        build-essential \
        libtinfo-dev \
        libpcre3-dev \
        libpq-dev

# Install ghcup/ghc/cabal
ENV BOOTSTRAP_HASKELL_NONINTERACTIVE 1
ENV BOOTSTRAP_HASKELL_INSTALL_NO_STACK 1
ENV BOOTSTRAP_HASKELL_INSTALL_NO_STACK_HOOK 1
ENV BOOTSTRAP_HASKELL_GHC_VERSION "9.2.5"
ENV BOOTSTRAP_HASKELL_CABAL_VERSION "3.8.1.0"

RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

ENV PATH "/root/.cabal/bin:/root/.ghcup/bin:$PATH"

RUN cabal update

###############################################################################
# Build graphql-engine
###############################################################################

# Clone repo, checkout demo branch
RUN git clone https://github.com/FinleyMcIlwaine/graphql-engine.git /graphql-engine
WORKDIR /graphql-engine
RUN git checkout finley/profiling-demo

# Build graphql-engine
RUN echo 12345 > "$(git rev-parse --show-toplevel)/server/CURRENT_VERSION"

RUN cabal install --project-file=cabal/dev-sh-prof-eventlog-socket.project exe:graphql-engine
