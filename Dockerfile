# syntax = docker/dockerfile:1

# Use the official Ruby image from the Docker Hub
ARG RUBY_VERSION=3.3.4
FROM ruby:$RUBY_VERSION-slim

# Install dependencies for building gems and running the application
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set environment variables
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Create and set working directory
RUN mkdir /app
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler && bundle install

# Copy the rest of the application code
COPY . .

# Ensure the db directory has the correct permissions
RUN chown -R root:root /app/db && chmod -R 0775 /app/db

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Expose port 3000 to the Docker host, so we can access it
EXPOSE 3000

# Start the main process
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
