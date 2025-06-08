# Project information
PROJECT_NAME := shapi
PACKAGE_NAME := shapi
PYTHON := python3
PIP := pip
POETRY := $(shell command -v poetry 2> /dev/null || echo "poetry")

# Source directory
SRC_DIR := src/shapi
CORE_DIR := $(SRC_DIR)/core

# Environment
PYTHON_ENV := .venv
PYTHON_BIN := $(PYTHON_ENV)/bin/python
PIP := $(PYTHON_ENV)/bin/pip

# Development
DEV_PORT := 8000
TEST_PATH := tests
COVERAGE_REPORT := htmlcov
DOCKER_COMPOSE := docker-compose

# Colors
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RED    := $(shell tput -Txterm setaf 1)
RESET  := $(shell tput -Txterm sgr0)

# Documentation
DOCS_PORT := 8001
DOCS_DIR := docs
BUILD_DIR := build
DIST_DIR := dist

# Python source files
PYTHON_SRC := $(shell find $(SRC_DIR) -type f -name '*.py')
PYTHON_TESTS := $(shell find $(TEST_PATH) -type f -name '*.py')

# Default target
.DEFAULT_GOAL := help

.PHONY: help
help:  ## Display this help
	@echo "$(YELLOW)$(PROJECT_NAME) - Makefile$(RESET)"
	@echo "\n$(WHITE)Usage: make $(GREEN)<target>$(RESET)"
	@echo "\n$(YELLOW)Available targets:$(RESET)"
	@awk 'BEGIN {FS = ":.*?##"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(GREEN)%-20s$(RESET) %s\n", $$1, $$2 }' $(MAKEFILE_LIST) | sort
	@echo "\nRun 'make <target>' where target is one of the above."

##@ Setup
install:  ## Install package in development mode with all dependencies
	@echo "$(YELLOW)Installing package in development mode...$(RESET)"
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -U poetry
	$(POETRY) install --with dev --extras "cli server"
	@echo "$(GREEN)✓ Package installed in development mode$(RESET)"

install-dev:  ## Install development dependencies
	@echo "$(YELLOW)Installing development dependencies...$(RESET)"
	$(POETRY) install --with dev
	@echo "$(GREEN)✓ Development dependencies installed$(RESET)"

install-hooks:  ## Install git hooks
	@echo "$(YELLOW)Installing pre-commit hooks...$(RESET)"
	$(POETRY) run pre-commit install
	@echo "$(GREEN)✓ Pre-commit hooks installed$(RESET)"

install-deps:  ## Install runtime dependencies
	@echo "$(YELLOW)Installing runtime dependencies...$(RESET)"
	$(POETRY) install --extras "cli"
	@echo "$(GREEN)✓ Runtime dependencies installed$(RESET)"

install-server:  ## Install server dependencies
	@echo "$(YELLOW)Installing server dependencies...$(RESET)"
	$(POETRY) install --extras "server"
	@echo "$(GREEN)✓ Server dependencies installed$(RESET)"

install-js:  ## Install JavaScript dependencies
	@echo "$(YELLOW)Installing JavaScript dependencies...$(RESET)
	npm install
	@echo "$(GREEN)✓ JavaScript dependencies installed$(RESET)"

install-deps: install-python install-js  ## Install all dependencies

check-env:  ## Check environment configuration
	@echo "$(YELLOW)Checking environment configuration...$(RESET)
	@if [ ! -f .env ]; then \
		echo "$(YELLOW)Warning: .env file not found. Creating from example...$(RESET)"; \
		cp -n .env.example .env; \
	fi
	@echo "$(GREEN)✓ Environment configuration checked$(RESET)"

##@ Run targets
start: start-dev  ## Alias for start-dev

start-dev: check-env  ## Start development server
	@echo "$(YELLOW)Starting development server...$(RESET)"
	@$(POETRY) run uvicorn shapi.api:app --reload --port $(DEV_PORT)

##@ Examples

# Port range for example services
EXAMPLE_PORTS := 8001 8002 8003 8004 8005 8006 8007

# Start all example services in the background
start-examples:
	@echo "$(YELLOW)Starting all example services...$(RESET)"
	@for port in $(EXAMPLE_PORTS); do \
		script=$$(echo "examples/"$$(ls examples/ | grep -v "^_" | grep -v "\." | head -n $$(( ($$port - 8000) )) | tail -n 1)); \
		if [ -f "$$script" ]; then \
			make service-daemon SERVICE_SCRIPT=$$script SERVICE_NAME=example-$$(basename $$script .sh) SERVICE_PORT=$$port; \
		sleep 1; \
		fi; \
	done

# Stop all example services
stop-examples:
	@echo "$(YELLOW)Stopping all example services...$(RESET)"
	@for port in $(EXAMPLE_PORTS); do \
		make service-stop SERVICE_NAME=example-$$(ls examples/ | grep -v "^_" | grep -v "\." | head -n $$(( ($$port - 8000) )) | tail -n 1 | cut -d. -f1); \
	done

# List all example services
list-examples:
	@echo "$(YELLOW)Listing example services...$(RESET)"
	@$(POETRY) run shapi service list | grep -E "$(shell echo $(EXAMPLE_PORTS) | sed 's/ /|/g')" || true

# Start a specific example
start-example:
	@if [ -z "$(EXAMPLE)" ]; then \
		echo "$(RED)Error: EXAMPLE not specified$(RESET)"; \
		echo "Usage: make start-example EXAMPLE=<name> [PORT=<port>]"; \
		exit 1; \
	fi
	@if [ ! -f "examples/$(EXAMPLE).sh" ]; then \
		echo "$(RED)Error: Example $(EXAMPLE).sh not found$(RESET)"; \
		exit 1; \
	fi
	@$(MAKE) service-daemon SERVICE_SCRIPT=examples/$(EXAMPLE).sh SERVICE_NAME=example-$(EXAMPLE) SERVICE_PORT=$(or $(PORT), 8001)

# Stop a specific example
stop-example:
	@if [ -z "$(NAME)" ]; then \
		echo "$(RED)Error: NAME not specified$(RESET)"; \
		echo "Usage: make stop-example NAME=<service-name>"; \
		exit 1; \
	fi
	@$(MAKE) service-stop SERVICE_NAME=$(NAME)

# Test all examples
test-examples:  ## Run example tests with pytest
	@echo "$(YELLOW)Running example tests...$(RESET)"
	@echo "$(YELLOW)Installing test dependencies...$(RESET)"
	@$(POETRY) install --with dev
	@echo "$(YELLOW)Starting example services...$(RESET)"
	@$(MAKE) start-examples
	@echo "$(YELLOW)Waiting for services to start...$(RESET)"
	@sleep 5
	@echo "$(YELLOW)Running tests...$(RESET)"
	@$(POETRY) run python -m pytest examples/test_examples.py -v --tb=short || ($(MAKE) stop-examples && exit 1)
	@$(MAKE) stop-examples

check-examples:  ## Verify example scripts work directly
	@echo "$(YELLOW)Verifying example scripts...$(RESET)"
	@$(PYTHON) examples/check_examples.py

##@ Service Management

SERVICE_SCRIPT ?= examples/hello.sh
SERVICE_NAME ?= $(shell basename $(SERVICE_SCRIPT) .sh)
SERVICE_PORT ?= 8000
SERVICE_HOST ?= 0.0.0.0

service-serve:  ## Start a service from a script
	@echo "$(YELLOW)Starting service from $(SERVICE_SCRIPT)...$(RESET)"
	@$(POETRY) run shapi serve $(SERVICE_SCRIPT) --name $(SERVICE_NAME) --port $(SERVICE_PORT) --host $(SERVICE_HOST)

service-daemon:  ## Start a service in the background
	@echo "$(YELLOW)Starting service in the background...$(RESET)"
	@$(POETRY) run shapi serve $(SERVICE_SCRIPT) --name $(SERVICE_NAME) --port $(SERVICE_PORT) --host $(SERVICE_HOST) --daemon

service-list:  ## List all running services
	@echo "$(YELLOW)Listing running services...$(RESET)"
	@$(POETRY) run shapi service list

service-stop:  ## Stop a running service
	@echo "$(YELLOW)Stopping service $(SERVICE_NAME)...$(RESET)"
	@$(POETRY) run shapi service stop $(SERVICE_NAME)

service-restart:  ## Restart a service
	@echo "$(YELLOW)Restarting service $(SERVICE_NAME)...$(RESET)
	@$(POETRY) run shapi service restart $(SERVICE_NAME)

start-ollama:  ## Start Ollama server (required for local development)
	@echo "$(YELLOW)Starting Ollama server...$(RESET)
	@echo "$(YELLOW)Note: Keep this running in a separate terminal$(RESET)"
	ollama serve

run-example:  ## Run the example script
	@echo "$(YELLOW)Running example...$(RESET)"
	$(POETRY) run python -m shapi.shapi

start-prod: check-env  ## Start production server
	@echo "$(YELLOW)Starting production server on port $(PROD_PORT)...$(RESET)"
	@$(POETRY) run uvicorn shapi.api:app --host 0.0.0.0 --port $(PROD_PORT)

start-docker:  ## Start using Docker
	@echo "$(YELLOW)Starting with Docker...$(RESET)"
	@$(DOCKER_COMPOSE) up --build

##@ Test & Lint
test: test-unit test-examples  ## Run all tests (unit + examples)

##@ Testing

test-unit:  ## Run unit tests
	@echo "$(YELLOW)Running unit tests...$(RESET)"
	@if [ -d "$(TEST_PATH)" ]; then \
		$(POETRY) run pytest $(TEST_PATH) -v; \
	else \
		echo "$(YELLOW)No tests found in $(TEST_PATH)$(RESET)"; \
	fi

test-cov:  ## Run tests with coverage
	@echo "$(YELLOW)Running tests with coverage...$(RESET)"
	@if [ -d "$(TEST_PATH)" ]; then \
		$(POETRY) run pytest --cov=$(SRC_DIR) --cov-report=term-missing --cov-report=html $(TEST_PATH) -v; \
	else \
		echo "$(YELLOW)No tests found in $(TEST_PATH)$(RESET)"; \
	fi

lint:  ## Run all linters
	@echo "$(YELLOW)Running linters...$(RESET)"
	$(POETRY) run black --check $(SRC_DIR) $(TEST_PATH)
	$(POETRY) run flake8 $(SRC_DIR) $(TEST_PATH)
	$(POETRY) run mypy $(SRC_DIR) $(TEST_PATH)

format:  ## Format code
	@echo "$(YELLOW)Formatting code...$(RESET)"
	$(POETRY) run black $(SRC_DIR) $(TEST_PATH)
	$(POETRY) run isort $(SRC_DIR) $(TEST_PATH)

check: lint test  ## Run all checks (lint and test)

##@ Build
build:  ## Build package
	@echo "$(YELLOW)Building package...$(RESET)"
	$(POETRY) version patch
	$(POETRY) build
	@echo "$(GREEN)✓ Package built in dist/$(RESET)"

##@ Publish
publish: build  ## Publish package to PyPI
	@echo "$(YELLOW)Publishing to PyPI...$(RESET)"
	$(POETRY) publish

##@ Cleanup
clean:  ## Remove build and test artifacts
	@echo "$(YELLOW)Cleaning up...$(RESET)"
	@# Python
	@find . -name '*.pyc' -exec rm -f {} +
	@find . -name '*.pyo' -exec rm -f {} +
	@find . -name '*~' -exec rm -f {} +
	@find . -name '__pycache__' -exec rm -fr {} +
	@find . -name '.pytest_cache' -exec rm -fr {} +
	@rm -f .coverage coverage.xml
	@rm -rf $(COVERAGE_REPORT)
	# Build artifacts
	@rm -rf $(BUILD_DIR) $(DIST_DIR) *.egg-info
	@echo "$(GREEN)✓ Clean complete$(RESET)

clean-all: clean  ## Remove all artifacts including virtualenvs
	@echo "$(YELLOW)Removing virtual environments...$(RESET)"
	@rm -rf $(PYTHON_ENV) .venv/
	@echo "$(GREEN)✓ All clean!$(RESET)"

clean-node:  ## Remove node_modules
	@echo "$(YELLOW)Cleaning node modules...$(RESET)"
	@rm -rf $(NODE_MODULES) 2>/dev/null || true
	@rm -f package-lock.json 2>/dev/null || true

clean-docker:  ## Stop and remove Docker containers and volumes
	@echo "$(YELLOW)Cleaning Docker containers and volumes...$(RESET)"
	@if command -v docker-compose >/dev/null 2>&1; then \
		docker-compose down -v --remove-orphans || true; \
	else \
		echo "$(YELLOW)Docker Compose not found, skipping...$(RESET)"; \
	fi

##@ Documentation
docs:  ## Generate documentation
	@echo "$(YELLOW)Generating documentation...$(RESET)"
	@$(POETRY) run mkdocs build

serve-docs:  ## Serve documentation locally
	@echo "$(YELLOW)Serving documentation at http://localhost:$(DOCS_PORT)$(RESET)"
	@$(POETRY) run mkdocs serve -a 127.0.0.1:$(DOCS_PORT)

update-docs:  ## Update API documentation
	@echo "$(YELLOW)Updating API documentation...$(RESET)"
	@$(POETRY) run mkdocs build --clean
	@echo "$(GREEN)✓ Documentation updated$(RESET)"


##@ Docker
docker-up:  ## Start Docker containers
	@echo "$(YELLOW)Starting Docker containers...$(NC)"
	@$(DOCKER_COMPOSE) up -d

docker-down:  ## Stop Docker containers
	@echo "$(YELLOW)Stopping Docker containers...$(NC)"
	@$(DOCKER_COMPOSE) down

docker-logs:  ## Show Docker logs
	@echo "$(YELLOW)Showing Docker logs...$(NC)"
	@$(DOCKER_COMPOSE) logs -f

##@ Cleanup
clean:  ## Clean build artifacts
	@echo "$(YELLOW)Cleaning build artifacts...$(RESET)"
	@rm -rf build/ dist/ *.egg-info/ htmlcov/ .coverage .pytest_cache/
	@find . -name '*.pyc' -delete
	@find . -name '__pycache__' -delete

clean-docs:  ## Clean documentation build
	@echo "$(YELLOW)Cleaning documentation...$(RESET)"
	@rm -rf site/

clean-all: clean clean-docs  ## Clean everything
	@echo "$(YELLOW)Cleaning everything...$(RESET)"
	@rm -rf .mypy_cache/ .pytest_cache/ .coverage htmlcov/
	@find . -name '*.pyc' -delete -o -name '__pycache__' -delete -o -name '.pytest_cache' -delete
	@echo "$(GREEN)✓ All clean!$(RESET)"
	@echo "$(GREEN)✓ Clean complete$(NC)"

clean-all: clean  ## Clean everything (including Docker)
	@echo "$(YELLOW)Cleaning Docker containers and volumes...$(NC)"
	@$(DOCKER_COMPOSE) down -v --remove-orphans
	@echo "$(GREEN)✓ All clean!$(NC)"

##@ Help
help:  ## Show this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\n$(YELLOW)Usage:$(NC)\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Phony Targets
.PHONY: setup-env install install-dev test test-cov lint format docs serve-docs \
        build publish docker-up docker-down docker-logs clean clean-all help

# Generate documentation
docs:
	@echo "Generating documentation..."
	@mkdir -p docs
	$(POETRY) run sphinx-apidoc -o docs/source $(PACKAGE_NAME)
	$(POETRY) run sphinx-build -b html docs/source docs/build

# Generate portfolio
portfolio:
	$(POETRY) run python -m $(PACKAGE_NAME).cli generate-portfolio

# Initialize git repository
git-init:
	git init
	git add .
	git commit -m "Initial commit"

