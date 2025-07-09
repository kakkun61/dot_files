PWSH=pwsh

SHELLCHECK_SEVERITY=style
SHELLCHECK=shellcheck --external-sources --severity $(SHELLCHECK_SEVERITY) --color

PSSCRIPTANALYZER_ENABLEEXIT= # -EnableExit

.PHONY: lint
lint: sh.lint bash.lint pwsh.lint

.PHONY: sh.lint
sh.lint:
	$(SHELLCHECK) --shell sh ./sh/lib.sh

.PHONY: bash.lint
bash.lint:
	$(SHELLCHECK) --shell bash ./bash/lib.bash
	$(SHELLCHECK) --shell bash ./bash/.bash_profile.example
	$(SHELLCHECK) --shell bash ./bash/.bashrc.example
	$(SHELLCHECK) --shell bash ./bash/.bash_logout.example

.PHONY: pwsh.lint
pwsh.lint:
	$(PWSH) -Command "Invoke-ScriptAnalyzer $(PSSCRIPTANALYZER_ENABLEEXIT) -Path .\pwsh\lib.ps1"
	$(PWSH) -Command "Invoke-ScriptAnalyzer $(PSSCRIPTANALYZER_ENABLEEXIT) -Path .\pwsh\profile.example.ps1"

spell:
	npm run cspell
