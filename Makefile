ENV      = $(CURDIR)/env
PIP      = $(ENV)/bin/pip
DEV_DEPS = install -r requirements/dev.txt

test: | $(ENV)/bin/coverage
	$(ENV)/bin/coverage run --rcfile=coverage.cfg -m unittest discover ./tests
	$(ENV)/bin/coverage report --rcfile=coverage.cfg
	$(ENV)/bin/coverage html --rcfile=coverage.cfg
	touch htmlcov

test-watch: | $(ENV)/bin/sniffer
	$(ENV)/bin/sniffer

shell: | $(ENV)/bin/bpython
	$(ENV)/bin/bpython

clean:
	find . -name "__pycache__" -exec rm -rf {} \;
	rm -rf $(ENV) htmlcov

$(ENV)/bin/bpython: | $(PIP)
	$(PIP) $(DEV_DEPS)

$(ENV)/bin/coverage: | $(PIP)
	$(PIP) $(DEV_DEPS)

$(ENV)/bin/sniffer: | $(PIP)
	$(PIP) $(DEV_DEPS)

$(PIP): | env
	$(PIP) install -r requirements/base.txt

env:
	virtualenv -p `which python` $(ENV)
	$(PIP) install pip --upgrade
