FROM eclipse-temurin:21-jammy
ARG VERSION_NODE="18.x"

# Install dependencies, including Node.js
RUN curl -sL "https://deb.nodesource.com/setup_${VERSION_NODE}" | bash - \
  && apt-get update \
  && apt-get -y install libblosc1 libbrotli1 postgresql-client libdraco4 git nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set the working directory
RUN mkdir -p /webknossos
WORKDIR /webknossos

# Copy the application's binaries to the container
COPY target/universal/stage .

# Setup user and group
RUN addgroup --system --gid 999 webknossos \
  && adduser --system --uid 999 --ingroup webknossos webknossos \
  && mkdir disk \
  && chown -R webknossos:webknossos . \
  && chmod -R go+rwx .

# Create a custom entrypoint
RUN echo '#!/bin/bash\numask 000\nbin/webknossos "$@"\n' > /docker-entrypoint.sh \
  && chmod +x /docker-entrypoint.sh

# Health check to ensure the service is running
HEALTHCHECK --interval=1m --timeout=5s --retries=10 \
  CMD curl --fail http://localhost:9000/api/buildinfo || exit 1

# Switch to non-root user
USER webknossos

# Expose the port the app runs on
EXPOSE 9000

# Set the container's entry point
ENTRYPOINT [ "/docker-entrypoint.sh" ]
