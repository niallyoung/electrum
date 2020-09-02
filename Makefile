SHELL := /bin/bash
ENV ?= dev # dev|test|prod

include env/default.env

.PHONY: all describe clean venv install lint build deploy run-local test test-single test-cover test-local-ci

all: describe clean venv install
# TODO resolve lint and test errors
#all: describe clean venv install lint test

describe:
	@echo "#################### make describe"
	@echo "PROJECT_ROOT="$(PROJECT_ROOT)
	@echo "SHELL="$(SHELL)
	@echo "ENV="$(ENV)
	@echo "PYTHON_VERSION="$(PYTHON_VERSION)
	@echo "LANG="$(LANG)
	@echo "PYTHONPATH="$(PYTHONPATH)
	@echo "POETRY_VIRTUALENVS_CREATE=$(POETRY_VIRTUALENVS_CREATE)"
	@echo "POETRY_VIRTUALENVS_IN_PROJECT=$(POETRY_VIRTUALENVS_IN_PROJECT)"
	@echo "POETRY_VIRTUALENVS_PATH=$(POETRY_VIRTUALENVS_PATH)"

clean:
	@echo "#################### make clean"
	rm -rf $(PROJECT_ROOT)/.venv

venv:
	@echo "#################### make venv"
	mkdir -p $(PROJECT_ROOT)/.venv
	python$(PYTHON_VERSION) -m venv .venv

install: venv
	@echo "#################### make install"
	source env/default.env && \
	source .venv/bin/activate && \
	poetry install

lint:
	@echo "#################### make lint"
	source env/default.env && \
	source .venv/bin/activate && \
	pylint -E --ignore=bin,lib,__init__.py electrum/* *.py

build:
	@echo "#################### make build"

deploy:
	@echo "#################### make deploy"

test:
	@echo "#################### make test"
	source env/default.env && \
	source .venv/bin/activate && \
	pytest -v -n auto electrum/tests

test-single:
	@echo "#################### make test-single"
	source env/default.env && \
	source .venv/bin/activate && \
	pytest -n 1 -v electrum/tests --random-order-bucket=global

test-cover:
	@echo "#################### make test-cover"
	source env/default.env && \
	source .venv/bin/activate && \
	pytest -n auto --cov=electrum --cov-report=term electrum/tests

test-local-ci:
	@echo "#################### make test-local-ci"
	source env/default.env && \
	source .venv/bin/activate && \
	pytest -f -n auto electrum/tests
