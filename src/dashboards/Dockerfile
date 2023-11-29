# Declare a build argument for the version
ARG VERSION
ARG BRANCH_NAME


# Use OpenSearch image as base
FROM opensearchproject/opensearch-dashboards:${VERSION}

# Set the working directory
WORKDIR /usr/share/opensearch-dashboards

# Switch to root to install necessary packages
USER root

# Install Git, Node.js, and Yarn
RUN yum update -y && \
    yum install -y git && \
    curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install -y nodejs && \
    npm install --global yarn

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
