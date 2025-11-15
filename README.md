# **Frappe CI/CD Deployment Pipeline**

This repository provides a lightweight, production-ready CI/CD pipeline for deploying Frappe/ERPNext applications using GitHub Actions and a secure SSH-based deployment script.

The workflow automatically triggers on merges or pushes to the `workflow_branch` branch, connects to the target server via SSH, pulls the latest code, builds assets, runs migrations, and restarts services — ensuring consistent, repeatable, and error-free deployments.

---

## 🚀 Features

* Automated deployments on every push or PR merge
* Secure SSH authentication via GitHub Secrets
* Reusable and extensible `deploy.sh` script
* Compatible with all Frappe/ERPNext custom apps
* Zero manual deployment steps
* Optional log rotation for deployment logs
* Easy to extend for multi-environment (dev/stage/prod) setups

---

## 📁 Repository Structure

```
frappe-deploy-pipeline/
├── deploy.yml
├── deploy.sh
├── LICENSE
├── deploy-logs
└── README.md
```

---

## ⚙️ Requirements

Before using this pipeline, ensure the following:

* A running Frappe/ERPNext server with SSH access
* SSH key pair configured (private key stored in GitHub Secrets)
* GitHub Secrets added to the repository:

  * `SSH_HOST` — Server hostname or IP
  * `SSH_USER` — SSH username
  * `SSH_KEY` — Private key for authentication
* Your Frappe/ERPNext app is a valid bench-managed module
* Git installed on the remote server and accessible to the bench user

---

## 🔧 Important Configuration (deploy.sh Variables)

Before running the deployment pipeline, update the following variables inside `deploy.sh` to match your environment:

```bash
SITE="site.local"                  # Your Frappe/ERPNext site
APP="custom_app"                   # App to deploy
BENCH_DIR="$HOME/frappe-bench"     # Full path to your bench directory
DEPLOY_BRANCH="develop"            # Branch used for deployment
```

These values must be accurate for deployments to work correctly.

---

## 🛠 GitHub Actions Workflow

- Move the workflow file to `.github/workflows/`
- The workflow file is located at:

```
.github/workflows/deploy.yml
```

The workflow:

1. Checks out the repository
2. Loads SSH credentials from GitHub Secrets
3. Executes the `deploy.sh` script
4. Initiates the deployment on the remote server

This enables seamless deployments triggered through GitHub without manual server interaction.

## NOTE: Please use the deploy.sh file's absolute path inside the deployment.yml file and change the `workflow_branch` to desired branch before enabling this workflow

---

## 🔧 Deployment Script (`deploy.sh`)

`deploy.sh` performs the following operations on the target server:

* Authenticate using the provided SSH key
* Navigate to the bench directory
* Fetch and reset the app to the latest commit
* Build frontend assets
* Run database migrations
* Restart Frappe/ERPNext services

You may modify this script depending on your deployment style or infrastructure requirements.

---

## 📦 Deployment Process

A deployment is triggered automatically when:

* A pull request is merged into `workflow_branch`, or
* Direct commits are pushed to `workflow_branch`

Deployment steps executed by GitHub Actions:

1. Checkout repository
2. Authenticate using SSH
3. Transfer and run the deploy script
4. Pull the latest code from the selected branch
5. Build frontend assets
6. Migrate the Frappe site
7. Restart bench processes

This ensures consistent, repeatable deployments across all environments.

---

## 🌀 Log Rotation (Optional but Recommended)

This repository includes an example **logrotate** configuration to manage deployment logs created by `deploy.sh`.

**File:**

```
deploy-logs
```


### What this configuration does

* Rotates logs **daily**
* Keeps **7 compressed** backups
* Deletes logs older than **6 days**
* Stores rotated logs in an `archive/` directory
* Ensures logs are created with proper user permissions

This prevents unnecessary disk usage over time.

---

## 🔐 Security Notes

* Store all sensitive values in **GitHub Secrets**
* Never hardcode SSH keys or credentials
* GitHub runners store private keys only in memory and destroy them after execution
* Ensure the bench user has appropriate permissions for deployment operations

---

## 🧩 Customization

This pipeline can be extended to support:

* Staging/production workflows
* Multi-site or multi-app deployments
* Pre-deployment checks (linting, syntax checks, test suites)
* Slack/Telegram notifications
* Docker-based Frappe deployments
* Matrix deployments across multiple servers

---

## 📄 License

This project is licensed under the **MIT License**.
See the full license here: [LICENSE](./LICENSE)

---

## 🤝 Contributions

Contributions, issues, and feature requests are welcome.
Feel free to open a pull request or create an issue.
