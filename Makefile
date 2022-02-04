.PHONY: clean clean-build clean-pyc clean-test coverage dist docs install lint lint/flake8 lint/black
.DEFAULT_GOAL:=test

PYTHON_PKG_NAME=johntest

clean: clean-build clean-pyc clean-test

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

######

lint/flake8: ## check style with flake8
	flake8 src/$(PYTHON_PKG_NAME) tests

lint/black: ## check style with black
	black --check src/$(PYTHON_PKG_NAME) tests

lint: lint/flake8 lint/black ## check style

######

requirements-txt:
	pip freeze > requirements.txt

######

test: ## run tests quickly with the default Python
	pytest

#test-all: ## run tests on every Python version with tox
#	tox

######

coverage: ## check code coverage quickly with the default Python
	coverage run --source src/$(PYTHON-PKG_NAME) -m pytest
	coverage report -m

coverage-html: coverage
	coverage html

######

docs: 
	cd docs && make clean

docs-html: docs
	cd docs && make html

######

#release: dist ## package and upload a release
#	twine upload dist/*

######

dist: clean ## builds source and wheel package
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist

######

install: clean ## install the package to the active Python's site-packages
	python setup.py install

new-project-setup:
	rm -f AUTHORS.rst CHANGELOG.rst CONTRIBUTING.rst LICENSE.txt
	rm -f docs/authors.rst docs/changelog.rst docs/contributing.rst docs/license.rst 
	perl -p -i -e 's/.+Authors.+\n//' docs/index.rst
	perl -p -i -e 's/.+Changelog.+\n//' docs/index.rst
	perl -p -i -e 's/.+Contributing.+\n//' docs/index.rst
	perl -p -i -e 's/.+License.+\n//' docs/index.rst
	pip install pip wheel setuptools build pytest pytest-cov flake8 black pre-commit isort --upgrade
	pip install --editable .
	pre-commit autoupdate
	
