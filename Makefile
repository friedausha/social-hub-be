# Variables
DOCKER_COMPOSE = docker compose
RAILS_ENV = development
DB_NAME = socialhub_development
WEB_SERVICE = web
TEST_SERVICE = test

.PHONY: build up down start stop restart logs db-setup db-reset test

# Build and start services
build:
	$(DOCKER_COMPOSE) build

# Start services in the background
up:
	$(DOCKER_COMPOSE) up -d

# Stop services
down:
	$(DOCKER_COMPOSE) down

# Start services (foreground)
start: up

# Stop services
stop: down

# Restart services
restart: down up

# Show logs
logs:
	$(DOCKER_COMPOSE) logs -f

# Setup the database
db-setup:
	$(DOCKER_COMPOSE) run $(WEB_SERVICE) bundle exec rake db:setup

# Reset the database
db-reset:
	$(DOCKER_COMPOSE) run $(WEB_SERVICE) bundle exec rake db:reset

# Run tests
test:
	$(DOCKER_COMPOSE) run -e $(RAILS_ENV) $(TEST_SERVICE) bundle exec rspec
