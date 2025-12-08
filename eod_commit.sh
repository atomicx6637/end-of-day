#!/bin/bash

# This script automates committing and pushing changes for all git repositories
# within the '/home/trichard/projects' directory.
# It also reports on directories that are not git repositories or have no remote.

# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error.
set -u

# --- Configuration ---
CONFIG_FILE="$HOME/.eod_config.sh"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Configuration file not found at '$CONFIG_FILE'."
  echo "Please create it and define GIT_USERNAME and GIT_EMAIL."
  exit 1
fi

source "$CONFIG_FILE"

if [[ "$GIT_USERNAME" == "Your Name" || "$GIT_EMAIL" == "your.email@example.com" ]]; then
  echo "Error: Please update your credentials in '$CONFIG_FILE'."
  exit 1
fi

PROJECTS_DIR="/home/trichard/projects"

if [[ ! -d "$PROJECTS_DIR" ]]; then
  echo "Projects directory not found: $PROJECTS_DIR"
  exit 1
fi

for dir in "$PROJECTS_DIR"/*; do
  if [[ -d "$dir" ]]; then
    if [[ -d "$dir/.git" ]]; then
      echo "--- Checking project: $dir ---"
      ( # Run in a subshell to avoid cd issues
        cd "$dir"

        # Check for remote
        if ! git remote -v | grep -q 'origin'; then
            echo "Warning: No 'origin' remote configured."
        fi

        # Check if there are any changes
        if [[ -z "$(git status --porcelain)" ]]; then
          echo "No changes to commit."
          exit 0
        fi

        echo "Changes detected. Adding, committing, and pushing..."

        git add .

        # Create a descriptive commit message
        commit_message="chore: End-of-day auto-commit on $(date -R)

Files changed:
$(git status --porcelain)"

        git -c "user.name=${GIT_USERNAME}" -c "user.email=${GIT_EMAIL}" commit -F - <<< "$commit_message"

        # Push to the remote repository
        if git push origin HEAD; then
          echo "Successfully pushed changes."
        else
          current_branch=$(git rev-parse --abbrev-ref HEAD)
          echo "Push failed. Attempting to set upstream for branch '$current_branch'."
          if git push --set-upstream origin "$current_branch"; then
            echo "Successfully pushed changes and set upstream."
          else
            echo "Error: Failed to push changes for project '$dir'. Manual intervention may be required." >&2
          fi
        fi
      )
    else
      echo "--- Info: $dir is not a git repository. ---"
    fi
  fi
done

echo "--- Script finished ---"
