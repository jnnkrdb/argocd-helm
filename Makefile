CHART_PATH = argocd
RESULT_PATH = $(TEST_FILES_PATH)/results
TEST_FILES_PATH = .testing
TEST_FILES = $(wildcard $(TEST_FILES_PATH)/*.yaml)
LOCAL_DEPS_PATH = $(wildcard dependencies/*/)

all: lint template package

# dependency tasks
dep:
	$(foreach v,$(LOCAL_DEPS_PATH),echo "$(v)" && helm dep up $(v)/;)
	helm dep up $(CHART_PATH)/

resultsdir:
	mkdir -p $(RESULT_PATH)

clean:
	rm -fR *.tgz $(CHART_PATH)/Chart.lock $(CHART_PATH)/charts $(RESULT_PATH)
	$(foreach v,$(LOCAL_DEPS_PATH),rm -fR $(v)Chart.lock $(v)charts;)

# helm testing

lint: resultsdir dep $(TEST_FILES)
	$(foreach v,$(TEST_FILES),echo "$(v)" && helm lint $(CHART_PATH)/ -f $(v);)

template: resultsdir dep $(TEST_FILES)
	$(foreach v,$(TEST_FILES),echo "$(v)" && helm template --debug $(CHART_PATH)/ -f $(v) > $(RESULT_PATH)/$(subst $(TEST_FILES_PATH)/,,$(v));)

package: resultsdir dep
	helm package $(CHART_PATH)/ --destination $(RESULT_PATH)