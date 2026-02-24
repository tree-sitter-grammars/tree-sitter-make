===========================================
Real-world variable value with parentheses
===========================================
PREPEND_STDOUT = | awk '{ print "$(CYAN_DIM)$(1):$(NC)", $$0; fflush(); }'

---

(makefile
  (variable_assignment
    name: (word)
    value: (text
      (variable_reference
        (word))
      (variable_reference
        (word))
      (variable_reference
        (word))
      (escape))))

==========================================
Shell function with nested parentheses
==========================================
VENV_SITE = $(shell $(UV_RUN) python -c "import sysconfig; print(sysconfig.get_path('purelib'))")

---

(makefile
  (variable_assignment
    name: (word)
    value: (text
      (shell_function
        (shell_command
          (variable_reference
            (word)))))))

==========================================
Non-shell function with nested parentheses
==========================================
MSG = $(info hello(world(foo)) bar)

---

(makefile
  (variable_assignment
    name: (word)
    value: (text
      (function_call
        (arguments
          argument: (text))))))

=========================================
Assignment operators
=========================================
MAKEFLAGS += --no-builtin-rules
MAKEARGS += --warn-undefined-variables
PYTHON ?= python3
SHELL := bash -o pipefail

---

(makefile
  (variable_assignment
    (word)
    (text))
  (variable_assignment
    (word)
    (text))
  (variable_assignment
    (word)
    (text))
  (variable_assignment
    (word)
    (text)))

=============================================
Export with nested functions
=============================================
export PROJECT_HOME ?= $(patsubst %/,%, $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

---

(makefile
  (export_directive
    (variable_assignment
      (word)
      (text
        (function_call
          (arguments
            (text
              (function_call
                (arguments
                  (text
                    (function_call
                      (arguments
                        (text
                          (function_call
                            (arguments
                              (text
                                (variable_reference
                                  (word))))))))))))))))))

=============================================
ifeq with nested $(shell ...) and export
=============================================
OS_NAME := $(shell uname)

ifeq ($(OS_NAME), Linux)
    OS_NAME := distro$(shell echo "$$VERSION_ID" | cut -f1 -d.)

    export JOB_RES ?= $(OS_NAME)&&$(shell arch)
endif

---

(makefile
  (variable_assignment
    (word)
    (text
      (shell_function
        (shell_command))))
  (conditional
    (ifeq_directive
      (variable_reference
        (word))
      (word))
    (variable_assignment
      (word)
      (text
        (shell_function
          (shell_command
            (escape)))))
    (export_directive
      (variable_assignment
        (word)
        (text
          (variable_reference
            (word))
          (shell_function
            (shell_command)))))))

=========================================
Nested ifneq/ifeq/else with ${...}
=========================================
ifneq ("$(wildcard /opt/tools/bin/runner)", "")
RUNNER                       := /opt/tools/bin/runner
ifeq ($(OS_NAME),distro9)
    RUNNER_WITH_FEATURE := $(RUNNER) +pkg +feature/9.9.9
else
    RUNNER_WITH_FEATURE := $(RUNNER) +pkg +feature/8.8.8
endif
RUNNER_WITH_PLUGIN   := $(RUNNER_WITH_FEATURE) +vendor +tool/${tool_version}
endif

---

(makefile
  (conditional
    (ifneq_directive
      (string
        (function_call
          (arguments
            (text))))
      (string))
    (variable_assignment
      (word)
      (text))
    (conditional
      (ifeq_directive
        (variable_reference
          (word))
        (word))
      (variable_assignment
        (word)
        (text
          (variable_reference
            (word))))
      (else_directive
        (variable_assignment
          (word)
          (text
            (variable_reference
              (word))))))
    (variable_assignment
      (word)
      (text
        (variable_reference
          (word))
        (variable_reference
          (word))))))

=========================================
Parens and $$ escapes in variable values
=========================================
PREPEND_STDOUT = | awk '{ print "$(CYAN_DIM)$(1):$(NC)", $$0; fflush(); }'
INTRO          = @echo -e "$(CYAN_BOLD)Running $@$(NC)"

COLOR_PATTERN = | $(SED) "s/$(1)/$$(printf "$(2)\\\0$(NC)")/g"

---

(makefile
  (variable_assignment
    (word)
    (text
      (variable_reference
        (word))
      (variable_reference
        (word))
      (variable_reference
        (word))
      (escape)))
  (variable_assignment
    (word)
    (text
      (variable_reference
        (word))
      (automatic_variable)
      (variable_reference
        (word))))
  (variable_assignment
    (word)
    (text
      (variable_reference
        (word))
      (variable_reference
        (word))
      (escape)
      (variable_reference
        (word))
      (variable_reference
        (word)))))

=========================================
Concatenated paths and export PATH
=========================================
export PATH := $(BIN_DIR):$(PWD)/scripts:$(PATH)
TOOL_PREFIX := .deps/tool/$(PLATFORM)
TOOL := $(TOOL_PREFIX)/bin/tool

---

(makefile
  (export_directive
    (variable_assignment
      (word)
      (text
        (variable_reference
          (word))
        (variable_reference
          (word))
        (variable_reference
          (word)))))
  (variable_assignment
    (word)
    (text
      (variable_reference
        (word))))
  (variable_assignment
    (word)
    (text
      (variable_reference
        (word)))))

=========================================
Special targets
=========================================
.DELETE_ON_ERROR:

---

(makefile
  (rule
    (targets
      (word))))

=========================================
Rule with multiline prerequisites
=========================================
.PHONY: envs
envs: \
    .env_linux_x86_64 \
    .env_linux_aarch64 \
    .env_macos_x86_64 \
    .env_macos_aarch64

---

(makefile
  (rule
    (targets
      (word))
    (prerequisites
      (word)))
  (rule
    (targets
      (word))
    (prerequisites
      (word)
      (word)
      (word)
      (word))))

=========================================
Pattern rule with order-only prerequisites and eval
=========================================
.env_%: config.toml | $(TOOL)
	$(eval OS=$(word 1,$(subst _, ,$*)))
	$(eval ARCH=$(word 2,$(subst _, ,$*)))

	CACHE_DIR=$(XDG_CACHE_HOME)/tool_$* \
	JOB_RES="$(OS)&&$(ARCH)" \
		./build env NAME=$@

---

(makefile
  (rule
    (targets
      (word))
    (prerequisites
      (word))
    (prerequisites
      (variable_reference
        (word)))
    (recipe
      (recipe_line
        (shell_text
          (function_call
            (arguments
              (text
                (function_call
                  (arguments
                    (text
                      (function_call
                        (arguments
                          (text
                            (automatic_variable))))))))))))
      (recipe_line
        (shell_text
          (function_call
            (arguments
              (text
                (function_call
                  (arguments
                    (text
                      (function_call
                        (arguments
                          (text
                            (automatic_variable))))))))))))
      (recipe_line
        (shell_text
          (variable_reference
            (word))
          (automatic_variable)
          (variable_reference
            (word))
          (variable_reference
            (word))
          (automatic_variable))))))

=========================================
Variable reference target and continued recipe lines
=========================================
$(TOOL):
	mkdir -p $(TOOL_PREFIX)
	$(PYTHON) -m pip install --upgrade \
		--index-url $(PYPI_INDEX) \
		--prefix $(TOOL_PREFIX) tool

---

(makefile
  (rule
    (targets
      (variable_reference
        (word)))
    (recipe
      (recipe_line
        (shell_text
          (variable_reference
            (word))))
      (recipe_line
        (shell_text
          (variable_reference
            (word))
          (variable_reference
            (word))
          (variable_reference
            (word)))))))

=========================================
Multiple pattern targets with slashes
=========================================
src/% tests/% docs/%: setup phony_explicit
	$(TEST_RUNNER) run $@

---

(makefile
  (rule
    (targets
      (word)
      (word)
      (word))
    (prerequisites
      (word)
      (word))
    (recipe
      (recipe_line
        (shell_text
          (variable_reference
            (word))
          (automatic_variable))))))

=========================================
Doctest recipe with continuation and $(call ...)
=========================================
.PHONY: doctest
doctest:
	$(INTRO)
	@$(RUNNER) \
	./scripts/doctest.tcl ./spec/* \
		$(call FORMAT_STDOUT,$@)

---

(makefile
  (rule
    (targets
      (word))
    (prerequisites
      (word)))
  (rule
    (targets
      (word))
    (recipe
      (recipe_line
        (shell_text
          (variable_reference
            (word))))
      (recipe_line
        (shell_text
          (variable_reference
            (word))
          (function_call
            (arguments
              (text
                (automatic_variable)))))))))

=========================================
Generated file rule with wildcard prerequisites
=========================================
src/cli_args_def.py: data/schema.json $(TOOL) scripts/gen_cli_args.py spec/*
	$(TOOL_RUN) ./scripts/gen_cli_args.py $< --output $@
	@$(LINTER) check --fix $@ --quiet
	@$(FORMATTER) format $@ --quiet

---

(makefile
  (rule
    (targets
      (word))
    (prerequisites
      (word)
      (variable_reference
        (word))
      (word)
      (word))
    (recipe
      (recipe_line
        (shell_text
          (variable_reference
            (word))
          (automatic_variable)
          (automatic_variable)))
      (recipe_line
        (shell_text
          (variable_reference
            (word))
          (automatic_variable)))
      (recipe_line
        (shell_text
          (variable_reference
            (word))
          (automatic_variable))))))
