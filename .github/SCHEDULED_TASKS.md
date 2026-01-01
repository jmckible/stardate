# Scheduled Tasks Setup

This repository uses GitHub Actions to run scheduled tasks on Fly.io.

## Tasks

### 1. Daily Recurring Transactions (`recur.rake`)
- **Schedule**: Every day at 5:30 AM PST (13:30 UTC)
- **Command**: `rails recur`
- **Purpose**: Creates transactions from recurring items scheduled for today

### 2. Account Funding (`accounts.rake fund`)
- **Schedule**: 1st and 15th of each month at 5:30 AM PST (13:30 UTC)
- **Command**: `rails accounts:fund`
- **Purpose**: Funds accounts with budgets and manages accrued savings

## Setup Instructions

### 1. Generate a Fly.io API Token

Run this command to create a deploy token for your organization:

```bash
fly tokens create deploy -x 999999h
```

Copy the generated token.

### 2. Add Token to GitHub Secrets

1. Go to your GitHub repository: https://github.com/jmckible/stardate
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `FLY_API_TOKEN`
5. Value: Paste the token from step 1
6. Click **Add secret**

### 3. Test the Workflow

You can manually trigger the workflow to test it:

1. Go to **Actions** tab in your GitHub repository
2. Click **Scheduled Tasks** workflow
3. Click **Run workflow** dropdown
4. Select which task to run:
   - `recur`: Test daily recurring transactions
   - `accounts:fund`: Test account funding
   - `both`: Run both tasks
5. Click **Run workflow**

### 4. Monitor Workflow Runs

- View workflow run history in the **Actions** tab
- Each run shows detailed logs
- You'll receive email notifications if workflows fail (configurable in GitHub settings)

## Timing Details

- **PST to UTC conversion**: PST is UTC-8, so 5:30 AM PST = 13:30 UTC
- **Off-peak scheduling**: Uses `:30` (half-hour) instead of top of hour to avoid GitHub Actions high-load periods
- **Cost**: Essentially free (<$0.01/month) - only pays for seconds when Fly machine is running

## How It Works

1. GitHub Actions triggers at scheduled time
2. Workflow installs `flyctl` CLI tool
3. Makes an HTTP request to `https://stardate.fly.dev/` to wake up your stopped machine
4. Waits 5 seconds for machine to fully start
5. Connects via SSH using the API token and runs the Rails task
6. Your Fly machine auto-stops after 5 minutes of inactivity
7. Total runtime: typically 15-35 seconds per task (including wake-up time)

## Troubleshooting

### Task didn't run
- Check **Actions** tab for workflow run history
- Verify `FLY_API_TOKEN` secret is set correctly
- GitHub Actions scheduled workflows can be delayed during high-load periods (rare but possible)

### Task failed
- Click into the failed workflow run to see detailed logs
- Common issues:
  - Fly.io API token expired or invalid
  - App not found or wrong app name
  - Rails task error (check logs)

### Manual execution
You can always run tasks manually:
```bash
fly ssh console -a stardate -C "rails recur"
fly ssh console -a stardate -C "rails accounts:fund"
```

## Reliability Notes

Based on GitHub's documentation:
- Scheduled workflows may be delayed during high-load periods (especially top of hour)
- Some jobs may be dropped if load is extremely high (rare)
- We mitigate this by scheduling at `:30` instead of `:00`
- Monitor the Actions tab for the first 2 weeks to ensure reliability

If you observe missed executions, consider switching to a dedicated worker machine on Fly.io (~$2/month).
