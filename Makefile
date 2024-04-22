# ARGS
# ------------------------------------------------------------------------------
COMPOSE_FILE=compose.dev.yaml
ENV_FILE=--env-file .env.dev
# ------------------------------------------------------------------------------
DJANGO=app
POSTGRES=db
PGADMIN4=db_admin
NGINX=web
MAILHOG=smtp
# ------------------------------------------------------------------------------
SERVICE=$(DJANGO)
# ------------------------------------------------------------------------------
COMMAND=python manage.py migrate

# RULES
# ------------------------------------------------------------------------------

# DOCKER
# ------------------------------------------------------------------------------

# Build services
build:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) build;

# Start containers
start:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) up;

# Start containers in detached mode
start-d:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) up -d;

# Build images before starting containers
build-start:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) up --build;

# Build images before starting containers in detached mode
build-start-d:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) up -d --build;

# Stop and remove all containers, networks.
down:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) down;

# Stop and remove containers, networks. Remove named volumes declared in the
# "volumes" section of the Compose file and anonymous volumes attached to containers.
down-v:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) down -v;

# Remove all the dangling images
image-prune:
	docker image prune -f

# Stop and remove all the containers, build services again, remove all the dangling images
# and start the containers.
down-build-clean-start: down build image-prune start

# Stop and remove all the containers, build services again, remove all the dangling images
# and start the containers in detached mode.
down-build-clean-start-d: down build image-prune start-d

# Stop and remove all the containers inc. volumes, build services again, remove all the dangling images
# and start the containers.
down-v-build-clean-start: down-v build image-prune start

# Stop and remove all the containers inc. volumes, build services again, remove all the dangling images
# and start the containers in detached mode.
down-v-build-clean-start-d: down-v build image-prune start-d

# Execute command in a running container
execute:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) exec $(SERVICE) $(COMMAND);

# Display the running processes
top:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) top

# View output from a container
logs:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) logs -f $(SERVICE)

# View output from containers
logs-all:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) logs

# View output from containers. Follow log output
logs-all-f:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) logs -f

# List containers
list:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) ps

# DJANGO
# ------------------------------------------------------------------------------

# Create a Django app
startapp:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) exec $(DJANGO) python manage.py startapp $(DJANGO_APP_NAME);

# Create migration files from database model
makemigrations:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) exec $(DJANGO) python manage.py makemigrations;

# Apply migrations
migrate:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) exec $(DJANGO) python manage.py migrate;

# Django migrations
migrations: makemigrations migrate;

# TESTING
# ------------------------------------------------------------------------------

# Run pytest
pytest:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) exec $(DJANGO) pytest;

# Run pytest and stop executing further tests if any test fails
pytest-x:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) exec $(DJANGO) pytest -x;

# Run pytest coverage
pytest-cov:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) exec $(DJANGO) pytest --cov;

# Generate HTML coverage report
cov-html:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) exec $(DJANGO) coverage html;


# LINTING (HTML TEMPLATES)
# ------------------------------------------------------------------------------
djlint:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) exec $(DJANGO) djlint project/templates/ --lint

djlint-reformat:
	docker compose -f $(COMPOSE_FILE) $(ENV_FILE) exec $(DJANGO) djlint project/templates/ --reformat
