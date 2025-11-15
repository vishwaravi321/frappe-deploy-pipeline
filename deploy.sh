#deploy.sh

#!/usr/bin/env bash

SITE=site.local
APP=custom_app
BENCH_DIR=~/frappe-bench
DEPLOY_BRANCH=develop

# error check : stop on the first error, not continuing the entire script
set -e

# log creation : storing logs for future debugging
timestamp=$(date +"%Y-%m-%d_%H-%M-%S") # making time stamp for the log naming
LOG_DIR="$HOME/deployment-logs"
LOGFILE="$LOG_DIR/deployment-${timestamp}.log"
mkdir -p "$(dirname "$LOGFILE")" # will check the dir exists else create it 
mkdir -p "$(dirname "$LOGFILE/archive")" # will check the dir exists else create it 

exec > >(tee -a "$LOGFILE") 2>&1  # will dump the output and error streams to the log file


# deployment:
echo "===== STARTING DEPLOYMENT: $(date) ====="
cd $BENCH_DIR || { echo "Bench directory not found."; exit 1; }  # changing to the bench directory and through error if not exist


echo "===== SWITCHING BRANCH TO DEVELOP: $(date) ====="
bench switch-to-branch $DEPLOY_BRANCH $APP   # switch branch to desired branch using bench CLI

# pulling latest code:
echo "===== PULLING LATEST CODES FROM BRANCH DEVELOP: $(date) ====="
cd $BENCH_DIR/apps/$APP || { echo "App directory not found."; exit 1; }
git fetch --depth=1 --no-tags upstream develop # only fetching last commit
git reset --hard upstream/develop # clean local repo
git reflog expire --all # removing any local flags present
git gc --prune=all # pruning(permenantly deleting) every other codes than the last one commit

echo "===== MIGRATING $SITE: $(date) ====="
# migrating the site: 
bench --site $SITE  migrate
echo "===== RESTARTING BENCH: $(date) ====="
# bench restart:
bench restart

echo "===== DEPLOYMENT FINISHED: $(date) ====="
