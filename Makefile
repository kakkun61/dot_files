PWSH=pwsh

SHELLCHECK_SEVERITY=style
SHELLCHECK=shellcheck --external-sources --severity $(SHELLCHECK_SEVERITY) --color

PSSCRIPTANALYZER_ENABLEEXIT= # -EnableExit

.PHONY: lint
lint:
	$(SHELLCHECK) --shell sh ./sh/lib.sh
	$(SHELLCHECK) --shell bash ./bash/lib.bash
	$(SHELLCHECK) --shell bash ./bash/.bash_profile.example
	$(SHELLCHECK) --shell bash ./bash/.bashrc.example
	$(SHELLCHECK) --shell bash ./bash/.bash_logout.example
	$(PWSH) -Command "Invoke-ScriptAnalyzer $(PSSCRIPTANALYZER_ENABLEEXIT) -Path .\pwsh\lib.ps1"
	$(PWSH) -Command "Invoke-ScriptAnalyzer $(PSSCRIPTANALYZER_ENABLEEXIT) -Path .\pwsh\profile.example.ps1"
