.SHELLFLAGS := -ec

SKILLS := $(notdir $(wildcard skill/*))

.PHONY: all
all: install-skills

.PHONY: install-skills
install-skills: install-skills-claude install-skills-cursor

.PHONY: install-skills-claude
install-skills-claude:
	@mkdir -p "$(HOME)/.claude/skills";
	for s in $(SKILLS); do ln -sfn $(CURDIR)/skill/$$s "$(HOME)/.claude/skills/$$s"; done;

.PHONY: install-skills-cursor
install-skills-cursor:
	@mkdir -p "$(HOME)/.cursor/skills";
	for s in $(SKILLS); do ln -sfn $(CURDIR)/skill/$$s "$(HOME)/.cursor/skills/$$s"; done;
