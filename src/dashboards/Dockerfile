# Declare a build argument for the version
ARG VERSION=2.11.0
ARG BRANCH_NAME=feature/metrics-editor-and-promql-demo-nov6-141300

# Use OpenSearch image as base
FROM opensearchproject/opensearch-dashboards:${VERSION}

# Echo the arguments to confirm their values
RUN echo "Building with OpenSearch Dashboards version: $VERSION" && \
    echo "Using branch: $BRANCH_NAME"

# Set the working directory
WORKDIR /usr/share/opensearch-dashboards

# Switch to root to install necessary packages
USER root

# Install Git
RUN yum update -y && \
    yum install -y git

# Install NVM, Node.js, and Yarn
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 16.16.0

RUN mkdir -p $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    npm install --global yarn

# Add NVM binaries to PATH for subsequent commands
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Copy the build script
COPY build-plugin.sh /usr/share/opensearch-dashboards/

# Set permissions and run the build script
RUN chmod +x /usr/share/opensearch-dashboards/build-plugin.sh && \
    /usr/share/opensearch-dashboards/build-plugin.sh $VERSION $BRANCH_NAME

# Switch back to opensearch user
USER opensearch-dashboards

# Install the built plugin
RUN /usr/share/opensearch-dashboards/bin/opensearch-dashboards-plugin install file:///usr/share/built-plugins/observabilityDashboards-${VERSION}.zip
