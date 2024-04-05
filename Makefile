# ARGS
# ------------------------------------------------------------------------------
COMPOSE_FILE=compose.dev.yaml
# ------------------------------------------------------------------------------
DJANGO_SERVICE=web
DATABASE_SERVICE=database
NGINX_SERVICE=nginx
MAILHOG_SERVICE=mailhog
# ------------------------------------------------------------------------------
SERVICE=$(DJANGO_SERVICE)
SERVICES=$(DJANGO_SERVICE) $(DATABASE_SERVICE) $(NGINX_SERVICE) $(MAILHOG_SERVICE)
# ------------------------------------------------------------------------------
COMMAND=python manage.py migrate

# RULES
# ------------------------------------------------------------------------------

# DOCKER
# ------------------------------------------------------------------------------

# Build services
build:
	docker compose -f $(COMPOSE_FILE) build;

# Start container
start:
	docker compose -f $(COMPOSE_FILE) up;

# Start containers in detached mode
start-d:
	docker compose -f $(COMPOSE_FILE) up -d;

# Build images before starting containers
build-start:
	docker compose -f $(COMPOSE_FILE) up --build;

# Build images before starting containers in detached mode
build-start-d:
	docker compose -f $(COMPOSE_FILE) up -d --build;

# Stop and remove containers, networks.
down:
	docker compose -f $(COMPOSE_FILE) down $(SERVICES);

# Stop and remove all containers, networks.
down-all:
	docker compose -f $(COMPOSE_FILE) down;

# Stop and remove containers, networks. Remove named volumes declared in the
# "volumes" section of the Compose file and anonymous volumes attached to containers.
down-all-v:
	docker compose -f $(COMPOSE_FILE) down -v;

# Execute command in a running container
execute:
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) $(COMMAND);

# Display the running processes
top:
	docker compose -f $(COMPOSE_FILE) top;

# View output from a container
logs:
	docker compose -f $(COMPOSE_FILE) logs -f $(SERVICE);

# View output from containers
logs-all:
	docker compose -f $(COMPOSE_FILE) logs;

# View output from containers. Follow log output
logs-all-f:
	docker compose -f $(COMPOSE_FILE) logs -f;

# List containers
list:
	docker compose -f $(COMPOSE_FILE) ps;

# DJANGO
# ------------------------------------------------------------------------------

# Create a Django app (NOT RECOMMENDED)
startapp:
	docker compose -f $(COMPOSE_FILE) exec $(DJANGO_SERVICE) startapp;

# Create migration files from database model
makemigrations:
	docker compose -f $(COMPOSE_FILE) exec $(DJANGO_SERVICE) python manage.py makemigrations;

# Apply migrations
migrate:
	docker compose -f $(COMPOSE_FILE) exec $(DJANGO_SERVICE) python manage.py migrate;

# Django migrations
migrations: makemigrations migrate;

# TESTING
# ------------------------------------------------------------------------------

# Run pytest
pytest:
	docker compose -f $(COMPOSE_FILE) exec $(DJANGO_SERVICE) pytest;

# Run pytest and stop executing further tests if any test fails
pytest-x:
	docker compose -f $(COMPOSE_FILE) exec $(DJANGO_SERVICE) pytest -x;

# Run pytest coverage
pytest-cov:
	docker compose -f $(COMPOSE_FILE) exec $(DJANGO_SERVICE) pytest --cov;

# Generate HTML coverage report
cov-html:
	docker compose -f $(COMPOSE_FILE) exec $(DJANGO_SERVICE) coverage html;

# LINTING (HTML TEMPLATES)
# ------------------------------------------------------------------------------
djlint:
	docker compose -f $(COMPOSE_FILE) exec $(DJANGO_SERVICE) djlint project/templates/ --lint

djlint-reformat:
	docker compose -f $(COMPOSE_FILE) exec $(DJANGO_SERVICE) djlint project/templates/ --reformat
