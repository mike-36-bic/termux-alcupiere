#Garbageman Project

**Acupieré** is a forward-collapsing, reproducible Termux environment for modular project orchestration, archival, and state persistence.

- Persistent state tracking via `state.json`
- Tag-aware project organization
- Git alias configuration for rapid CLI workflows
- Bootstrap script for fresh Termux environments
- Archive and resume scripts for interruption resilience

```bash
./bin/init.sh           # Bootstrap Termux environment
./bin/resume.sh <proj>  # Resume project from last state
./bin/archive.sh <proj> # Archive and tag unresolved projects

After entering your GitHub username and repo name 
during `init.sh`, a file called `env/github.env` 
will be created. This file stores:

- `GH_USER`: Your GitHub username
- `GH_REPO`: The name of your GitHub repository
- `GH_URL`: The SSH URL used for pushing to GitHub

This file is sourced by other scripts to ensure consistent Git operations across sessions.
