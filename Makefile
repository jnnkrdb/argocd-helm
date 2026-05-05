# Makefile for ArgoCD Helm Chart

# This Makefile provides targets for linting, templating, and packaging the ArgoCD Helm Chart.

# Variables
CHART_PATH = .
TEST_FILES_PATH = .testing

# relative path to store results of helm template and helm package
RESULT_PATH = $(TEST_FILES_PATH)/results

# get all yaml files in the test directory
TEST_FILES = $(wildcard $(TEST_FILES_PATH)/*.yaml)

all: lint template package

# dependency tasks

dep:
	helm dep up $(CHART_PATH)/

resultsdir:
	mkdir -p $(RESULT_PATH)

clean:
	rm -fR *.tgz $(CHART_PATH)/Chart.lock $(CHART_PATH)/charts $(RESULT_PATH)

# helm testing

lint: clean dep $(TEST_FILES)
	$(foreach v,$(TEST_FILES),echo "$(v)" && helm lint $(CHART_PATH)/ -f $(v);)

template: clean resultsdir dep $(TEST_FILES)
	$(foreach v,$(TEST_FILES),echo "$(v)" && helm template --debug $(CHART_PATH)/ -f $(v) > $(RESULT_PATH)/$(subst $(TEST_FILES_PATH)/,,$(v));)

package: clean resultsdir dep
	helm package $(CHART_PATH)/ --destination $(RESULT_PATH)