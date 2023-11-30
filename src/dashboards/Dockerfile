# Declare a build argument for the version
ARG VERSION=2.11.0

# Use OpenSearch image as base
FROM opensearchproject/opensearch-dashboards:${VERSION}

# Re-declare ARG BRANCH_NAME to use within this build stage
ARG BRANCH_NAME=feature/metrics-editor-and-promql-demo-nov6-141300

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

# Clone the specific branch of the repository
RUN git clone --branch ${BRANCH_NAME} https://github.com/opensearch-project/dashboards-observability.git

# Change directory to the cloned repository
WORKDIR /usr/share/opensearch-dashboards/dashboards-observability

# Install dependencies and build the plugin
RUN yarn install && \
    yarn run build

# Go back to OpenSearch Dashboards directory
WORKDIR /usr/share/opensearch-dashboards

# Remove the existing plugin, if installed, and install the newly built one
RUN /usr/share/opensearch-dashboards/bin/opensearch-dashboards-plugin remove observabilityDashboards && \
    /usr/share/opensearch-dashboards/bin/opensearch-dashboards-plugin install file:///usr/share/opensearch-dashboards/dashboards-observability/build/observabilityDashboards.zip

# Cleanup: Remove the repository and other unnecessary packages to reduce image size
RUN rm -rf /usr/share/opensearch-dashboards/dashboards-observability && \
    yum remove -y git nodejs && \
    yum clean all

# Switch back to opensearch user
USER opensearch-dashboards
