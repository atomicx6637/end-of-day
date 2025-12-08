# Gemini Context: End-of-Day Project

## Project Overview

This project contains a single shell script, `eod_commit.sh`, designed to automate the process of committing and pushing changes for all Git repositories located within a specified projects directory (`/home/trichard/projects`).

The script iterates through each subdirectory, checks if it's a Git repository, and if there are any pending changes. If changes are detected, it automatically adds them, creates a descriptive commit message, and pushes the changes to the `origin` remote.

## Building and Running

This is a shell script and does not require a build process.

### Dependencies

The script depends on a configuration file located at `~/.eod_config.sh`. This file must exist and contain the following variables:

```bash
# ~/.eod_config.sh

GIT_USERNAME="Your Name"
GIT_EMAIL="your.email@example.com"
```

### Running the Script

To execute the script, run the following command from the project directory:

```bash
./eod_commit.sh
```

Make sure the script has execute permissions (`chmod +x eod_commit.sh`).

## Development Conventions

*   **Error Handling:** The script uses `set -e` to exit immediately on errors and `set -u` to treat unset variables as errors.
*   **Configuration:** All user-specific configuration (Git user name and email) is externalized to the `~/.eod_config.sh` file.
*   **Commit Messages:** The script generates standardized commit messages with the format `chore: End-of-day auto-commit on <Date>` followed by a list of changed files.
*   **Subshells:** Git commands are run within a subshell for each directory to prevent `cd` from affecting the main script's execution context.
